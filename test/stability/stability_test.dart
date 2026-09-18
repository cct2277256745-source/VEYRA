import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veyra/ai/ai_provider.dart';
import 'package:veyra/ai/mock_ai_provider.dart';
import 'package:veyra/ai/openai_compatible_provider.dart';
import 'package:veyra/ai/plan_application_service.dart';
import 'package:veyra/ai/replanner_service.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/core/utils/week.dart';
import 'package:veyra/data/app_services.dart';
import 'package:veyra/features/import/document_import_service.dart';

/// Slice 2.9 稳定性矩阵（PRD §22）：任何 AI / 文件失败都不允许影响本地项目使用。
void main() {
  late AppServices services;

  setUp(() {
    services = AppServices.inMemory();
  });

  tearDown(() => services.close());

  test('① 重启：文件数据库关闭重开数据完整（真实 App 同路径逻辑）', () async {
    final dir = await Directory.systemTemp.createTemp('veyra_stability');
    addTearDown(() => dir.delete(recursive: true));
    final dbFile = File('${dir.path}/veyra.sqlite3');

    final first = AppServices.openFile(dbFile);
    final p = await first.projects.createProject(title: '重启测试');
    final phase = await first.projects.createPhase(p.id, '阶段');
    await first.projects
        .createTask(projectId: p.id, phaseId: phase.id, title: '任务');
    await first.close();

    final second = AppServices.openFile(dbFile);
    final loaded = await second.projects.getProject(p.id);
    expect(loaded!.title, '重启测试');
    expect(await second.projects.tasksOfProject(p.id), hasLength(1));
    await second.close();
  });

  test('② 无网：Mock Provider 离线可用，本地项目功能完整', () async {
    final offlinePlan = PlanApplicationService(
      provider: MockAIProvider(),
      services: services,
    );
    final proposal = await offlinePlan
        .generateFromGoal(AIBuildPlanRequest(goal: '无网也要能规划'));
    final project = await offlinePlan.confirmProposal(proposal.id);
    expect(project.title, contains('无网也要能规划'));

    // 无网状态下手动建项目/任务照常
    final manual = await services.projects.createProject(title: '手动项目');
    final phase = await services.projects.createPhase(manual.id, '阶段');
    await services.projects
        .createTask(projectId: manual.id, phaseId: phase.id, title: '手动任务');
    expect(await services.projects.listProjects(), hasLength(2));
  });

  test('③ API Key 错误：AI 报鉴权异常，本地功能不受影响', () async {
    final failingProvider = OpenAICompatibleProvider(
      config: const AIConfig(
          baseUrl: 'https://example.invalid/v1', model: 'm', apiKey: 'bad'),
      client: MockClient((request) async => http.Response('denied', 401)),
    );
    final planService = PlanApplicationService(
      provider: failingProvider,
      services: services,
    );
    await expectLater(
      planService.generateFromGoal(AIBuildPlanRequest(goal: 'x')),
      throwsA(isA<AIAuthException>()),
    );
    // 本地照常
    final p = await services.projects.createProject(title: '照常使用');
    expect(p.title, '照常使用');
  });

  test('④ AI JSON 格式错误：不污染本地数据', () async {
    final badProvider = OpenAICompatibleProvider(
      config: const AIConfig(
          baseUrl: 'https://example.invalid/v1', model: 'm', apiKey: 'k'),
      client: MockClient((request) async => http.Response(
          jsonEncode({
            'choices': [
              {
                'message': {'content': '{"project": {"title": ""}}'}
              }
            ]
          }),
          200)),
    );
    final planService = PlanApplicationService(
      provider: badProvider,
      services: services,
    );
    await expectLater(
      planService.generateFromGoal(AIBuildPlanRequest(goal: 'x')),
      throwsA(isA<AIFormatException>()),
    );
    expect(await services.proposals.undecided(), isEmpty);
    expect(await services.projects.listProjects(), isEmpty);
  });

  test('⑤ 文件损坏：损坏 DOCX 明确失败，数据零改动', () async {
    final service = DocumentImportService(saveSourceDocument: (_) async => 1);
    await expectLater(
      service.importFromBytes([0, 1, 2, 3], 'broken.docx'),
      throwsA(isA<ImportException>()),
    );
    expect((await services.projects.listProjects()), isEmpty);
  });

  test('⑥ 加密 PDF：明确提示，不产生任何数据', () async {
    final service = DocumentImportService(saveSourceDocument: (_) async => 1);
    final bytes = latin1
        .encode('%PDF-1.4\ntrailer\n<< /Encrypt 9 0 R >>\n%%EOF');
    await expectLater(
      service.importFromBytes(bytes, 'locked.pdf'),
      throwsA(predicate<ImportException>((e) => e.reason.contains('加密'))),
    );
    expect((await services.projects.listProjects()), isEmpty);
  });

  test('⑦ 删除被依赖的任务被拒绝，原数据完好', () async {
    final p = await services.projects.createProject(title: 'P');
    final phase = await services.projects.createPhase(p.id, '阶段');
    final a = await services.projects
        .createTask(projectId: p.id, phaseId: phase.id, title: '前置');
    final b = await services.projects
        .createTask(projectId: p.id, phaseId: phase.id, title: '后置');
    await services.projects.addDependency(b.id, a.id);

    expect(() => services.projects.deleteTask(a.id), throwsStateError);
    expect(await services.projects.getTask(a.id), isNotNull);
    expect(await services.projects.getTask(b.id), isNotNull);
  });

  test('⑧ 切换执行模式：Weekly → Project Only 清空周归属，任务本体不变', () async {
    final p = await services.projects.createProject(
        title: '雅思', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(p.id, '听力');
    final t = await services.projects.createTask(
        projectId: p.id, phaseId: phase.id, title: '精听');
    await services.week.assignTaskToWeek(t.id);

    await services.projects.setExecutionMode(p.id, ExecutionMode.projectOnly);

    expect(await services.week.weekItems(mondayOf(DateTime.now())), isEmpty);
    expect(await services.projects.getTask(t.id), isNotNull,
        reason: '周归属与 Task 本体分离（PRD §21）');
  });

  test('⑨ 拒绝 AI 调整：零改动', () async {
    final replanner =
        ReplannerService(provider: MockAIProvider(), services: services);
    final p = await services.projects.createProject(
        title: '雅思', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(p.id, '写作');
    final t = await services.projects.createTask(
        projectId: p.id, phaseId: phase.id, title: '写作 Task 2');
    await services.week.assignTaskToWeek(t.id);

    final proposal = await replanner.proposeChanges(situation: '有变化');
    await replanner.cancel(proposal.id);
    expect(await services.week.weekItems(mondayOf(DateTime.now())), hasLength(1));
  });

  test('⑩ 只应用一部分调整：partially_accepted，未选中的不生效', () async {
    final replanner =
        ReplannerService(provider: MockAIProvider(), services: services);
    final p = await services.projects.createProject(
        title: '雅思', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(p.id, '写作');
    final t = await services.projects.createTask(
        projectId: p.id, phaseId: phase.id, title: '雅思写作 Task 2');
    await services.week.assignTaskToWeek(t.id);

    final proposal = await replanner.proposeChanges(situation: '变化');
    await replanner.applyChanges(proposal.id, indexes: {0});

    final decided = (await services.proposals.get(proposal.id))!;
    expect(decided.status, ProposalStatus.partiallyAccepted);
  });

  test('⑪ 请求中途退出：异常请求后数据库仍可正常读写', () async {
    // 模拟：AI 请求进行中 App 关闭 —— 打开→写数据→关闭→重开仍可用。
    final dir = await Directory.systemTemp.createTemp('veyra_midrequest');
    addTearDown(() => dir.delete(recursive: true));
    final dbFile = File('${dir.path}/veyra.sqlite3');

    final first = AppServices.openFile(dbFile);
    final planService = PlanApplicationService(
      provider: MockAIProvider(),
      services: first,
    );
    final proposal = await planService
        .generateFromGoal(AIBuildPlanRequest(goal: '中途退出前的目标'));
    // 未确认即关闭（模拟用户中途退出）
    await first.close();

    final second = AppServices.openFile(dbFile);
    // 草稿还在，但未生效
    final draft = await second.proposals.get(proposal.id);
    expect(draft!.status, ProposalStatus.draft);
    expect(await second.projects.listProjects(), isEmpty);
    // 数据库仍可正常写入
    final p = await second.projects.createProject(title: '恢复后照常');
    expect(p.title, '恢复后照常');
    await second.close();
  });
}
