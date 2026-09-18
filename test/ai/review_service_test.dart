import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veyra/ai/ai_provider_factory.dart';
import 'package:veyra/ai/mock_ai_provider.dart' show MockAIProvider;
import 'package:veyra/ai/secure_key_store.dart';
import 'package:veyra/ai/review_service.dart';
import 'package:veyra/app/app.dart';
import 'package:veyra/app/app_scope.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/core/utils/week.dart';
import 'package:veyra/data/app_services.dart';

/// Slice 2.8：Progress Story 聚合逻辑与快照存储。
Future<void> _pump(WidgetTester tester, AppServices services) async {
  final factory = AIProviderFactory(
    settings: services.aiSettings,
    keyStore: InMemoryKeyStore(),
    debugProvider: MockAIProvider(),
  );
  await tester.pumpWidget(AIScope(
    factory: factory,
    child: AppScope(services: services, child: const VeyraApp()),
  ));
  await tester.pumpAndSettle();
}

void main() {
  late AppServices services;
  late ReviewService review;

  setUp(() {
    services = AppServices.inMemory();
    review = ReviewService(provider: MockAIProvider(), services: services);
  });

  tearDown(() => services.close());

  test('项目复盘：成果（outcomeNote）优先，里程碑与推迟分列，快照入库', () async {
    final project = await services.projects.createProject(
        title: 'AI 产品经理求职', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(project.id, '简历');
    final task = await services.projects.createTask(
      projectId: project.id,
      phaseId: phase.id,
      title: '优化简历',
    );
    await services.projects.completeTask(task.id, outcomeNote: '一份针对 AI PM 优化的简历');
    final milestone = await services.projects.createMilestone(phase.id, '简历定稿');
    await services.projects.completeMilestone(milestone.id);

    final story = await review.projectReview(project.id);

    expect(story.highlights, contains('优化简历：一份针对 AI PM 优化的简历'));
    expect(story.milestones, contains('简历定稿'));
    expect(story.completedCount, 1);
    expect(story.aiSummary, isNotNull);

    final snapshot =
        await services.progress.latestProjectSnapshot(project.id);
    expect(snapshot, isNotNull);
    expect(snapshot!.aiSummary, story.aiSummary);
    expect(snapshot.storyJson, contains('一份针对 AI PM 优化的简历'));
  });

  test('周复盘：聚合本周完成/推迟事件，快照按周存储', () async {
    final project = await services.projects.createProject(
        title: '雅思', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(project.id, '听力');
    final done = await services.projects.createTask(
        projectId: project.id, phaseId: phase.id, title: '精听练习');
    await services.projects.completeTask(done.id, outcomeNote: '3 段精听笔记');
    final deferred = await services.projects.createTask(
        projectId: project.id, phaseId: phase.id, title: '阅读模块 02');
    await services.projects.setTaskStatus(deferred.id, TaskStatus.deferred);

    final story = await review.weekReview();

    expect(story.completedCount, 1);
    expect(story.highlights, contains('精听练习：3 段精听笔记'));
    expect(story.deferred, contains('阅读模块 02'));

    final snapshot = await services.progress.latestWeekSnapshot(
        mondayOf(DateTime.now()));
    expect(snapshot, isNotNull);
    expect(snapshot!.storyJson, contains('阅读模块 02'));
  });

  test('空周期复盘也产出温和总结', () async {
    final story = await review.weekReview();
    expect(story.completedCount, 0);
    expect(story.aiSummary, isNotNull);
  });

  testWidgets('Week 页复盘入口 → 显示一句总结与成果区', (tester) async {
    await _pump(tester, services);
    await tester.tap(find.text('周计划'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();

    expect(find.text('本周复盘'), findsOneWidget);
    expect(find.text('你真正完成了'), findsOneWidget);
  });

  testWidgets('项目 Focus 页复盘入口 → 项目复盘页', (tester) async {
    await services.projects.createProject(title: '求职作品集');
    await _pump(tester, services);

    await tester.tap(find.text('求职作品集'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();

    expect(find.text('项目复盘'), findsOneWidget);
  });
}
