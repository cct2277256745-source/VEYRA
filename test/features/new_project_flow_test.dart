import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veyra/ai/ai_provider_factory.dart';
import 'package:veyra/ai/mock_ai_provider.dart';
import 'package:veyra/ai/secure_key_store.dart';
import 'package:veyra/app/app_scope.dart';
import 'package:veyra/data/app_services.dart';
import 'package:veyra/features/projects/new_project_flow.dart';

void main() {
  late AppServices services;
  late AIProviderFactory aiFactory;

  setUp(() {
    services = AppServices.inMemory();
    aiFactory = AIProviderFactory(
      settings: services.aiSettings,
      keyStore: InMemoryKeyStore(),
      debugProvider: MockAIProvider(),
    );
  });

  tearDown(() => services.close());

  Future<void> pumpDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      AIScope(
        factory: aiFactory,
        child: AppScope(
          services: services,
          child: const MaterialApp(
            home: Scaffold(
              body: Center(
                child: NewProjectFlowDialog(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('新建项目弹窗：标题为空时点击继续报错', (tester) async {
    await pumpDialog(tester);

    expect(find.text('创建项目'), findsOneWidget);
    await tester.tap(find.text('继续'));
    await tester.pumpAndSettle();

    expect(find.text('请先填写项目名称。'), findsOneWidget);
  });

  testWidgets('选择「让 VEYRA 帮我规划」进入目标与期望描述页，可补充产出与约束', (tester) async {
    await pumpDialog(tester);

    // Step 1: 输入项目名称
    await tester.enterText(find.byType(TextField), '雅思 8 周计划');
    await tester.tap(find.text('继续'));
    await tester.pumpAndSettle();

    expect(find.text('你想怎么开始？'), findsOneWidget);
    expect(find.text('让 VEYRA 帮我规划'), findsOneWidget);

    // Step 2: 点击「让 VEYRA 帮我规划」
    await tester.tap(find.text('让 VEYRA 帮我规划'));
    await tester.pumpAndSettle();

    // 验证进入 AI 规划描述页
    expect(find.text('让 VEYRA 帮我规划 · 意图对齐'), findsOneWidget);
    expect(find.textContaining('项目目标：雅思 8 周计划'), findsOneWidget);
    expect(find.textContaining('预期成果'), findsOneWidget);
    expect(find.textContaining('当前基础'), findsOneWidget);
    expect(find.textContaining('时间与节奏约束'), findsOneWidget);

    // 测试快捷标签点击：点击「8周冲刺」自动填入约束
    expect(find.text('8周冲刺'), findsOneWidget);
    await tester.ensureVisible(find.text('8周冲刺'));
    await tester.tap(find.text('8周冲刺'));
    await tester.pumpAndSettle();

    expect(find.textContaining('8周冲刺'), findsWidgets);

    // 验证「上一步」可返回选择页并保留数据
    await tester.tap(find.text('上一步'));
    await tester.pumpAndSettle();
    expect(find.text('你想怎么开始？'), findsOneWidget);

    // 再次进入「让 VEYRA 帮我规划」
    await tester.tap(find.text('让 VEYRA 帮我规划'));
    await tester.pumpAndSettle();
    expect(find.text('下一步：生成阶段蓝图'), findsOneWidget);

    // 点击「下一步：生成阶段蓝图」
    await tester.tap(find.text('下一步：生成阶段蓝图'));
    await tester.pumpAndSettle();

    // 验证进入中间确认门禁：阶段架构与里程碑确认
    expect(find.text('阶段架构与里程碑确认'), findsOneWidget);
    expect(find.text('确认阶段，细化任务'), findsOneWidget);
    expect(find.textContaining('阶段 1'), findsOneWidget);

    // 验证可点击「确认阶段，细化任务」进入细化预览
    await tester.tap(find.text('确认阶段，细化任务'));
    await tester.pumpAndSettle();

    // 验证成功进入草案预览页，展示任务勾选与选择性应用
    expect(find.text('确认规划草案'), findsOneWidget);
    expect(find.textContaining('已选'), findsOneWidget);
  });

  testWidgets('中间确认门禁：支持添加阶段、删除阶段、勾选剔除任务后落库', (tester) async {
    await pumpDialog(tester);

    // Step 1: 项目名称
    await tester.enterText(find.byType(TextField), 'Flutter 桌面端重构');
    await tester.tap(find.text('继续'));
    await tester.pumpAndSettle();

    // Step 2: 让 VEYRA 帮我规划
    await tester.tap(find.text('让 VEYRA 帮我规划'));
    await tester.pumpAndSettle();

    // Step 3: 生成阶段蓝图
    await tester.tap(find.text('下一步：生成阶段蓝图'));
    await tester.pumpAndSettle();

    // Step 4: 中间确认门禁
    expect(find.text('阶段架构与里程碑确认'), findsOneWidget);
    expect(find.textContaining('阶段 1'), findsOneWidget);
    expect(find.textContaining('阶段 2'), findsOneWidget);
    expect(find.textContaining('阶段 3'), findsOneWidget);

    // 测试添加新阶段
    expect(find.text('添加阶段'), findsOneWidget);
    await tester.ensureVisible(find.text('添加阶段'));
    await tester.tap(find.text('添加阶段'));
    await tester.pumpAndSettle();
    expect(find.textContaining('阶段 4'), findsWidgets);

    // 测试删除阶段（删除阶段 4）
    final closeButtons = find.byIcon(Icons.close_rounded);
    expect(closeButtons, findsWidgets);
    await tester.ensureVisible(closeButtons.last);
    await tester.tap(closeButtons.last);
    await tester.pumpAndSettle();
    expect(find.textContaining('阶段 4'), findsNothing);

    // 确认阶段架构，细化生成具体任务
    await tester.ensureVisible(find.text('确认阶段，细化任务'));
    await tester.tap(find.text('确认阶段，细化任务'));
    await tester.pumpAndSettle();

    // 进入全案预览页
    expect(find.text('确认规划草案'), findsOneWidget);
    final checkboxes = find.byType(Checkbox);
    expect(checkboxes, findsWidgets);

    // 剔除第一个任务（取消勾选）
    await tester.tap(checkboxes.first);
    await tester.pumpAndSettle();

    // 切换第二个任务的优先级
    final priorityPill = find.text('必做');
    if (priorityPill.evaluate().isNotEmpty) {
      await tester.tap(priorityPill.first);
      await tester.pumpAndSettle();
    }

    // 确认落库创建
    await tester.tap(find.text('确认，创建项目'));
    await tester.pumpAndSettle();

    // 验证数据库项目落库正确
    final projects = await services.projects.listProjects();
    expect(projects, isNotEmpty);
    final createdProject = projects.firstWhere((p) => p.title == 'Flutter 桌面端重构');
    expect(createdProject, isNotNull);

    // 验证剔除的任务未进入数据库
    final phases = await services.projects.phasesOfProject(createdProject.id);
    expect(phases.length, 3);
    final tasks = await services.projects.tasksOfProject(createdProject.id);
    // 初始有 6 个任务（每阶段2个），剔除1个后应为 5 个任务
    expect(tasks.length, 5);
  });
}
