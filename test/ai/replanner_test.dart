import 'package:flutter_test/flutter_test.dart';
import 'package:veyra/ai/ai_provider.dart';
import 'package:veyra/ai/mock_ai_provider.dart';
import 'package:veyra/ai/replanner_service.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/data/app_services.dart';
import 'package:veyra/core/utils/week.dart';

/// Slice 2.7 核心验收：未经确认不得修改任何数据。
void main() {
  late AppServices services;
  late ReplannerService replanner;

  setUp(() {
    services = AppServices.inMemory();
    replanner = ReplannerService(provider: MockAIProvider(), services: services);
  });

  tearDown(() => services.close());

  Future<void> seedWeeklyProject() async {
    final project = await services.projects
        .createProject(title: '雅思', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(project.id, '写作');
    final task = await services.projects.createTask(
      projectId: project.id,
      phaseId: phase.id,
      title: '雅思写作 Task 2',
      priority: TaskPriority.optional,
    );
    await services.week.assignTaskToWeek(task.id);
    final portfolio = await services.projects.createProject(
        title: '作品集', executionMode: ExecutionMode.projectOnly);
    final p2 = await services.projects.createPhase(portfolio.id, '视觉');
    await services.projects.createTask(
      projectId: portfolio.id,
      phaseId: p2.id,
      title: '作品集视觉',
    );
  }

  test('生成提案：只存草稿，数据零改动', () async {
    await seedWeeklyProject();
    final before =
        await services.week.weekItems(mondayOf(DateTime.now()));

    final proposal = await replanner.proposeChanges(situation: '这周做不完');
    expect(proposal.status, ProposalStatus.draft);
    expect(proposal.kind, 'rebalance');

    final after = await services.week.weekItems(mondayOf(DateTime.now()));
    expect(after.length, before.length, reason: '确认前数据零改动');
  });

  test('全部应用：移动周归属 + 优先级翻转 + 新增任务，提案 accepted', () async {
    await seedWeeklyProject();
    final proposal = await replanner.proposeChanges(situation: '这周做不完');

    final applied = await replanner.applyChanges(proposal.id);
    expect(applied, 3);

    // move_week：写作移到下周
    final thisWeek = await services.week.weekItems(mondayOf(DateTime.now()));
    final nextWeek =
        await services.week.weekItems(mondayOf(DateTime.now()).add(const Duration(days: 7)));
    expect(thisWeek.where((e) => e.$2.title == '雅思写作 Task 2'), isEmpty);
    expect(nextWeek.where((e) => e.$2.title == '雅思写作 Task 2'), hasLength(1));

    // add_task：周五面试准备加进本周
    final added = thisWeek.where((e) => e.$2.title == '周五面试准备');
    expect(added, isNotEmpty);

    final decided = (await services.proposals.get(proposal.id))!;
    expect(decided.status, ProposalStatus.accepted);
  });

  test('选择性应用：只应用所选，提案 partially_accepted', () async {
    await seedWeeklyProject();
    final proposal = await replanner.proposeChanges(situation: '有急事');
    // 只应用第 0 条（move_week）
    await replanner.applyChanges(proposal.id, indexes: {0});

    final thisWeek = await services.week.weekItems(mondayOf(DateTime.now()));
    expect(thisWeek.where((e) => e.$2.title == '雅思写作 Task 2'), isEmpty);

    // 新增任务（第 2 条）不应存在
    final all = await services.projects.tasksOfProject(
        (await services.projects.listProjects()).first.id);
    expect(all.where((t) => t.title == '周五面试准备'), isEmpty);

    final decided = (await services.proposals.get(proposal.id))!;
    expect(decided.status, ProposalStatus.partiallyAccepted);
  });

  test('取消：rejected，数据零改动', () async {
    await seedWeeklyProject();
    final proposal = await replanner.proposeChanges(situation: '变化');
    await replanner.cancel(proposal.id);
    final decided = (await services.proposals.get(proposal.id))!;
    expect(decided.status, ProposalStatus.rejected);
    expect(
        await services.week.weekItems(mondayOf(DateTime.now())),
        hasLength(1));
  });

  test('重复应用被拒绝', () async {
    await seedWeeklyProject();
    final proposal = await replanner.proposeChanges(situation: '变化');
    await replanner.applyChanges(proposal.id);
    await expectLater(
      replanner.applyChanges(proposal.id),
      throwsA(isA<AIException>()),
    );
  });

  test('AI 失败时不产生提案', () async {
    final failing = ReplannerService(
      provider: MockAIProvider(failWith: AINetworkException()),
      services: services,
    );
    await expectLater(
      failing.proposeChanges(situation: 'x'),
      throwsA(isA<AINetworkException>()),
    );
    expect(await services.proposals.undecided(), isEmpty);
  });
}
