import 'package:flutter_test/flutter_test.dart';
import 'package:veyra/ai/ai_provider.dart';
import 'package:veyra/ai/mock_ai_provider.dart';
import 'package:veyra/ai/plan_application_service.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/data/app_services.dart';

/// Slice 2.5 核心验收：AI 不允许直接覆盖当前项目；确认前零改动；失败不落库。
void main() {
  late AppServices services;
  late PlanApplicationService planService;

  setUp(() {
    services = AppServices.inMemory();
    planService = PlanApplicationService(
      provider: MockAIProvider(),
      services: services,
    );
  });

  tearDown(() => services.close());

  test('生成草案：只有 proposal 入库，项目零改动', () async {
    final proposal = await planService.generateFromGoal(
      AIBuildPlanRequest(goal: '8 周雅思冲刺'),
    );
    expect(proposal.status, ProposalStatus.draft);
    expect(proposal.payloadJson, contains('雅思'));

    final projects = await services.projects.listProjects();
    expect(projects, isEmpty, reason: '确认前不允许创建任何项目');
  });

  test('确认后：Project/Phase/Task 按草案创建，提案变为 accepted', () async {
    final proposal = await planService.generateFromGoal(
      AIBuildPlanRequest(goal: '8 周雅思冲刺'),
    );
    final project = await planService.confirmProposal(proposal.id);

    expect(project.title, contains('8 周雅思冲刺'));
    expect(project.executionMode, ExecutionMode.weeklyPlanning);

    final phases = await services.projects.phasesOfProject(project.id);
    expect(phases, hasLength(2));
    final tasks = await services.projects.tasksOfProject(project.id);
    expect(tasks.map((t) => t.title), contains('完成主要产出'));

    final decided =
        (await services.proposals.get(proposal.id))!;
    expect(decided.status, ProposalStatus.accepted);

    final events = await services.progress.eventsOfProject(project.id);
    expect(events.map((e) => e.type), contains(ProgressEventType.proposalApplied));
  });

  test('依赖按任务标题正确接线', () async {
    final proposal = await planService.generateFromGoal(
      AIBuildPlanRequest(goal: '普通项目'),
    );
    final project = await planService.confirmProposal(proposal.id);
    final tasks = await services.projects.tasksOfProject(project.id);
    final byTitle = {for (final t in tasks) t.title: t};
    final mainTask = byTitle['完成主要产出']!;
    final deps = await services.projects.dependenciesOfTask(mainTask.id);
    expect(deps, isEmpty);
    // 无声明的依赖不乱接
    final listTask = byTitle['列出现状清单']!;
    expect(await services.projects.dependenciesOfTask(listTask.id), isEmpty);
  });

  test('重复确认被拒绝', () async {
    final proposal = await planService.generateFromGoal(
      AIBuildPlanRequest(goal: '某目标'),
    );
    await planService.confirmProposal(proposal.id);
    await expectLater(
      planService.confirmProposal(proposal.id),
      throwsA(isA<AIException>()),
    );
  });

  test('AI 失败时不产生任何提案、不改动数据', () async {
    final failing = PlanApplicationService(
      provider: MockAIProvider(failWith: AINetworkException()),
      services: services,
    );
    await expectLater(
      failing.generateFromGoal(AIBuildPlanRequest(goal: 'x')),
      throwsA(isA<AINetworkException>()),
    );
    expect(await services.proposals.undecided(), isEmpty);
    expect(await services.projects.listProjects(), isEmpty);
  });

  test('拒绝提案：状态变 rejected，数据零改动', () async {
    final proposal = await planService.generateFromGoal(
      AIBuildPlanRequest(goal: '某目标'),
    );
    await planService.rejectProposal(proposal.id);
    final decided = (await services.proposals.get(proposal.id))!;
    expect(decided.status, ProposalStatus.rejected);
    expect(await services.projects.listProjects(), isEmpty);
  });

  test('文件解析：sourceQuote 生成来源引用挂到任务', () async {
    final proposal = await planService.generateFromFile(
      file: const ExtractedPlanFile(
          fileName: 'plan.md', text: '我的雅思计划……'),
    );
    final project = await planService.confirmProposal(proposal.id);
    final tasks = await services.projects.tasksOfProject(project.id);
    final withRef = tasks.where((t) => t.sourceRefId != null);
    expect(withRef, isNotEmpty);
    final ref = await services.projects.getSourceRef(withRef.first.sourceRefId!);
    expect(ref!.quote, isNotEmpty);
  });
}
