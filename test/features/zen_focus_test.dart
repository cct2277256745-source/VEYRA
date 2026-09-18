import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veyra/app/app_scope.dart';
import 'package:veyra/core/domain/entities.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/data/app_services.dart';
import 'package:veyra/features/zen/zen_breathing_ring.dart';
import 'package:veyra/features/zen/zen_focus_page.dart';

void main() {
  late AppServices services;
  late Project testProject;
  late Phase testPhase;
  late Task task1;
  late Task task2;

  setUp(() async {
    services = AppServices.inMemory();
    testProject = await services.projects.createProject(
      title: 'VEYRA 核心重构',
      outcome: '完成极简心流专注与设计系统',
    );
    testPhase = await services.projects.createPhase(
      testProject.id,
      '阶段一：体验打磨',
      goal: '打造纯粹无干扰的沉浸工作流',
    );
    task1 = await services.projects.createTask(
      projectId: testProject.id,
      phaseId: testPhase.id,
      title: '实现 4 秒呼吸相干性环形 Canvas 渲染',
      priority: TaskPriority.must,
      effort: EstimatedEffort.medium,
    );
    task2 = await services.projects.createTask(
      projectId: testProject.id,
      phaseId: testPhase.id,
      title: '接入 Things 3 触感复选与自动切题',
      priority: TaskPriority.optional,
      effort: EstimatedEffort.small,
    );
  });

  tearDown(() => services.close());

  group('ZenBreathingRing Widget', () {
    testWidgets('渲染时间、状态标签并支持正向流与呼吸微动', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ZenBreathingRing(
                progress: 0.5,
                timeDisplay: '25:00',
                stateLabel: '专注中 · 保持心流',
                isRunning: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('25:00'), findsOneWidget);
      expect(find.text('专注中 · 保持心流'), findsOneWidget);

      // 验证呼吸微动在周期内的稳定运行
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('25:00'), findsOneWidget);
    });
  });

  group('ZenFocusPage Interaction & Flow State', () {
    Future<void> pumpZenFocusPage(WidgetTester tester) async {
      await tester.pumpWidget(
        AppScope(
          services: services,
          child: MaterialApp(
            home: ZenFocusPage(
              project: testProject,
              phase: testPhase,
              initialTask: task1,
              remainingTasks: [task2],
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('展示当前攻坚任务锚点、模式切换与暂停恢复', (tester) async {
      await pumpZenFocusPage(tester);

      // 验证标题与任务锚点卡片
      expect(find.text(testProject.title), findsOneWidget);
      expect(find.text('阶段一：体验打磨'), findsOneWidget);
      expect(find.text(task1.title), findsOneWidget);
      expect(find.text('25:00'), findsOneWidget);
      expect(find.text('保持专注 · 心流推进中'), findsOneWidget);

      // 测试暂停 / 恢复
      await tester.tap(find.text('暂歇 (空格)'));
      await tester.pump();
      expect(find.text('心流已暂歇'), findsOneWidget);
      expect(find.text('继续专注 (空格)'), findsOneWidget);

      await tester.tap(find.text('继续专注 (空格)'));
      await tester.pump();
      expect(find.text('保持专注 · 心流推进中'), findsOneWidget);

      // 测试 +5 分钟
      expect(find.text('+5 分钟'), findsOneWidget);
      await tester.tap(find.text('+5 分钟'));
      await tester.pump();
      expect(find.text('30:00'), findsOneWidget);

      // 测试模式切换到「5m 休息」
      await tester.tap(find.text('5m 休息'));
      await tester.pump();
      expect(find.text('05:00'), findsOneWidget);

      // 测试模式切换到「正向流」
      await tester.tap(find.text('正向流'));
      await tester.pump();
      expect(find.text('00:00'), findsOneWidget);
    });

    testWidgets('Things 3 触感完成任务，自动持久化并切入队列下一题直至全部达成', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpZenFocusPage(tester);

      expect(find.text(task1.title), findsOneWidget);
      expect(find.text('标记任务已达成 (⌘ + Enter)'), findsOneWidget);

      // 点击完成第 1 个任务
      await tester.ensureVisible(find.text('标记任务已达成 (⌘ + Enter)'));
      await tester.tap(find.text('标记任务已达成 (⌘ + Enter)'));
      await tester.pump();
      expect(find.text('已完成！正在切换下一项行动...'), findsOneWidget);

      // 等待触感延迟过渡
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(milliseconds: 200));

      // 验证数据库中 task1 已标记完成
      final tasks = await services.projects.tasksOfProject(testProject.id);
      final t1 = tasks.firstWhere((t) => t.id == task1.id);
      expect(t1.isDone, isTrue);

      // 验证队列自动推进到 task2
      expect(find.text(task2.title), findsOneWidget);

      // 点击完成第 2 个任务
      await tester.ensureVisible(find.text('标记任务已达成 (⌘ + Enter)'));
      await tester.tap(find.text('标记任务已达成 (⌘ + Enter)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(milliseconds: 200));

      // 验证队列清空，进入静心达成状态
      expect(find.text('心流圆满完成'), findsOneWidget);
      expect(find.text('返回项目'), findsOneWidget);
    });
  });
}
