import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veyra/app/app.dart';
import 'package:veyra/app/app_scope.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/ai/ai_provider_factory.dart';
import 'package:veyra/ai/mock_ai_provider.dart';
import 'package:veyra/ai/secure_key_store.dart';
import 'package:veyra/data/app_services.dart';

/// Slice 2.6：Week 页面（周目标分组、容量、Project Only 隔离）。
void main() {
  late AppServices services;

  setUp(() {
    services = AppServices.inMemory();
  });

  tearDown(() => services.close());

  Future<void> pumpWeek(WidgetTester tester) async {
    final aiFactory = AIProviderFactory(
      settings: services.aiSettings,
      keyStore: InMemoryKeyStore(),
      debugProvider: MockAIProvider(),
    );
    await tester.pumpWidget(AIScope(
      factory: aiFactory,
      child: AppScope(services: services, child: const VeyraApp()),
    ));
    await tester.pumpAndSettle();
    // 切到周计划 tab
    await tester.tap(find.text('周计划'));
    await tester.pumpAndSettle();
  }

  testWidgets('Weekly 项目任务出现在本周；Project Only 不出现', (tester) async {
    final weekly = await services.projects
        .createProject(title: '雅思', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(weekly.id, '听力');
    final t1 = await services.projects.createTask(
        projectId: weekly.id, phaseId: phase.id, title: '完成阅读模块 02', priority: TaskPriority.must);
    await services.week.assignTaskToWeek(t1.id);

    final only = await services.projects
        .createProject(title: '作品集', executionMode: ExecutionMode.projectOnly);
    final p2 = await services.projects.createPhase(only.id, '研究');
    await services.projects
        .createTask(projectId: only.id, phaseId: p2.id, title: '写 Problem Statement');

    await pumpWeek(tester);

    expect(find.textContaining('完成阅读模块 02'), findsWidgets);
    expect(find.textContaining('写 Problem Statement'), findsNothing);
    expect(find.textContaining('作品集'), findsNothing);
  });

  testWidgets('容量切换写入仓储', (tester) async {
    await pumpWeek(tester);
    await tester.tap(find.text('生存模式'));
    await tester.pumpAndSettle();
    expect(
        await services.week.capacityOf(DateTime.now()), CapacityLevel.survival);
  });

  testWidgets('加入任务按钮列出 Weekly 项目未分配任务', (tester) async {
    final weekly = await services.projects
        .createProject(title: '求职', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(weekly.id, '简历');
    await services.projects
        .createTask(projectId: weekly.id, phaseId: phase.id, title: '优化简历');

    await pumpWeek(tester);
    await tester.tap(find.text('加入任务'));
    await tester.pumpAndSettle();

    expect(find.textContaining('优化简历'), findsOneWidget);
  });

  testWidgets('重新平衡：输入变化 → 预览拟调整 → 全部应用', (tester) async {
    final weekly = await services.projects
        .createProject(title: '雅思', executionMode: ExecutionMode.weeklyPlanning);
    final phase = await services.projects.createPhase(weekly.id, '写作');
    final task = await services.projects.createTask(
      projectId: weekly.id,
      phaseId: phase.id,
      title: '雅思写作 Task 2',
    );
    await services.week.assignTaskToWeek(task.id);

    await pumpWeek(tester);
    await tester.tap(find.text('重新平衡'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, '这周雅思做不完');
    await tester.tap(find.text('生成调整建议'));
    await tester.pumpAndSettle();

    expect(find.text('拟调整'), findsOneWidget);
    expect(find.textContaining('雅思写作 Task 2'), findsWidgets);

    await tester.tap(find.text('全部应用'));
    await tester.pumpAndSettle();

    // 写作任务已被顺延到下周（本周不再显示）
    expect(find.textContaining('雅思写作 Task 2'), findsNothing);
  });
}
