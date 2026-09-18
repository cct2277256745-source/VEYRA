import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veyra/ai/ai_provider_factory.dart';
import 'package:veyra/ai/mock_ai_provider.dart';
import 'package:veyra/ai/secure_key_store.dart';
import 'package:veyra/app/app.dart';
import 'package:veyra/app/app_scope.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/data/app_services.dart';

late AppServices testServices;

Future<void> pumpApp(
  WidgetTester tester, {
  Future<void> Function(AppServices services)? seed,
}) async {
  testServices = AppServices.inMemory();
  addTearDown(testServices.close);
  final aiFactory = AIProviderFactory(
    settings: testServices.aiSettings,
    keyStore: InMemoryKeyStore(),
    debugProvider: MockAIProvider(),
  );
  if (seed != null) {
    await seed(testServices);
  }
  await tester.pumpWidget(AIScope(
    factory: aiFactory,
    child: AppScope(services: testServices, child: const VeyraApp()),
  ));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('VeyraApp 外壳可启动且默认落在项目页', (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('VEYRA'), findsWidgets);
    expect(find.text('项目'), findsWidgets);
    expect(find.textContaining('还没有项目'), findsOneWidget);
  });

  testWidgets('新建项目 → 列表出现项目卡 → Focus View 显示目标与下一步',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(FilledButton, '新建项目').first);
    await tester.pumpAndSettle();

    // Step 1：项目名称
    await tester.enterText(find.byType(TextField), '雅思 8 周计划');
    await tester.tap(find.ancestor(
        of: find.text('继续'), matching: find.byType(FilledButton)));
    await tester.pumpAndSettle();

    // Step 2：从空白开始
    await tester.tap(find.text('从空白开始'));
    await tester.pumpAndSettle();

    // Step 3：加入周规划 → 创建
    await tester.tap(find.text('加入周规划'));
    await tester.pump();
    await tester.tap(find.text('创建项目'));
    await tester.pumpAndSettle();

    expect(find.text('雅思 8 周计划'), findsOneWidget);

    // 进入 Focus View
    await tester.tap(find.text('雅思 8 周计划'));
    await tester.pumpAndSettle();
    expect(find.text('查看完整规划'), findsOneWidget);
    expect(find.text('接下来'), findsOneWidget);
  });

  testWidgets('Plan View：手动建阶段与任务并可完成任务', (WidgetTester tester) async {
    await pumpApp(tester, seed: (services) async {
      final project = await services.projects.createProject(title: '减脂计划');
      final phase = await services.projects.createPhase(project.id, '饮食与活动');
      await services.projects.createTask(
        projectId: project.id,
        phaseId: phase.id,
        title: '记录饮食与步数',
        priority: TaskPriority.must,
      );
    });

    await tester.tap(find.text('减脂计划'));
    await tester.pumpAndSettle();
    expect(find.text('记录饮食与步数'), findsOneWidget);

    await tester.tap(find.text('查看完整规划'));
    await tester.pumpAndSettle();
    expect(find.text('阶段 · 饮食与活动'), findsOneWidget);
    expect(find.text('必做'), findsOneWidget);

    // 完成任务
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    // 完成后回到 Focus 会出现“查看完整规划”下方的进度变化；这里直接回到列表验证
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
  });

  testWidgets('路径 B：AI 生成草案 → 预览 → 确认后项目出现在列表',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(FilledButton, '新建项目').first);
    await tester.pumpAndSettle();

    // Step 1：名称 → 继续 → Step 2 选择 AI 路径
    await tester.enterText(find.byType(TextField), '8 周雅思冲刺计划');
    await tester.pump();
    await tester.tap(find.ancestor(
        of: find.text('继续'), matching: find.byType(FilledButton)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('让 VEYRA 帮我规划'));
    await tester.pumpAndSettle();

    // Step 3：意图与边界输入 → 下一步：生成阶段蓝图
    expect(find.text('下一步：生成阶段蓝图'), findsOneWidget);
    await tester.tap(find.text('下一步：生成阶段蓝图'));
    await tester.pumpAndSettle();

    // Step 4：阶段架构与里程碑确认门禁 → 确认阶段，细化任务
    expect(find.text('阶段架构与里程碑确认'), findsOneWidget);
    expect(find.text('确认阶段，细化任务'), findsOneWidget);
    await tester.tap(find.text('确认阶段，细化任务'));
    await tester.pumpAndSettle();

    expect(find.text('确认规划草案'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);

    await tester.tap(find.text('确认，创建项目'));
    await tester.pumpAndSettle();

    expect(find.textContaining('8 周雅思冲刺计划'), findsWidgets);
  });
}
