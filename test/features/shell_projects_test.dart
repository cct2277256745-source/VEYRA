import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veyra/app/app.dart';
import 'package:veyra/ai/ai_provider_factory.dart';
import 'package:veyra/ai/secure_key_store.dart';
import 'package:veyra/app/app_scope.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/data/app_services.dart';

/// Phase 3 Round 2：Global Shell + Projects。
void main() {
  late AppServices services;

  setUp(() {
    services = AppServices.inMemory();
  });

  tearDown(() => services.close());

  Future<void> pumpApp(WidgetTester tester) async {
    final factory = AIProviderFactory(
      settings: services.aiSettings,
      keyStore: InMemoryKeyStore(),
    );
    await tester.pumpWidget(AIScope(
      factory: factory,
      child: AppScope(services: services, child: const VeyraApp()),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('Shell：侧栏切换三个一级页面', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('周计划'));
    await tester.pumpAndSettle();
    expect(find.text('重新平衡'), findsOneWidget);

    await tester.tap(find.text('收件箱'));
    await tester.pumpAndSettle();
    expect(find.text('发生了什么？'), findsOneWidget);

    await tester.tap(find.text('项目'));
    await tester.pumpAndSettle();
    expect(find.text('你正在推进的路径。'), findsOneWidget);
  });

  testWidgets('Shell：侧栏底部设置入口打开设置页', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    expect(find.text('AI 服务'), findsOneWidget);
  });

  testWidgets('Projects：卡片含当前阶段/迷你路径/下一步，More 菜单可归档并恢复',
      (tester) async {
    final project = await services.projects.createProject(
      title: '健身 12 周计划',
      outcome: '完成 12 周训练',
      executionMode: ExecutionMode.weeklyPlanning,
    );
    final phase = await services.projects.createPhase(project.id, '动作复盘');
    await services.projects
        .createTask(projectId: project.id, phaseId: phase.id, title: '整理训练记录');
    final phase2 = await services.projects.createPhase(project.id, '训练节奏');
    await services.projects
        .createTask(projectId: project.id, phaseId: phase2.id, title: '安排恢复日');

    await pumpApp(tester);

    expect(find.textContaining('当前阶段 · 动作复盘'), findsOneWidget);
    expect(find.textContaining('下一步：整理训练记录'), findsOneWidget);

    // More 菜单 → 归档项目
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('归档项目'));
    await tester.pumpAndSettle();

    // 活动列表为空，出现已归档入口
    expect(find.textContaining('健身 12 周计划'), findsNothing);
    expect(find.text('已归档项目'), findsOneWidget);

    // 展开已归档 → 恢复
    await tester.tap(find.text('已归档项目'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('恢复项目'));
    await tester.pumpAndSettle();
    expect(find.textContaining('健身 12 周计划'), findsOneWidget);
  });

  testWidgets('Projects：空状态文案与新建入口', (tester) async {
    await pumpApp(tester);
    expect(find.text('还没有项目。'), findsOneWidget);
    expect(find.text('从一个目标开始，或者导入你已有的规划。'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '新建项目'), findsWidgets);
  });
}
