import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veyra/app/app.dart';
import 'package:veyra/app/app_scope.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/data/app_services.dart';

/// Phase 2.10：Inbox V1 最小功能。
void main() {
  late AppServices services;

  setUp(() {
    services = AppServices.inMemory();
  });

  tearDown(() => services.close());

  group('InboxRepository', () {
    test('编辑内容 / 删除 / 归档 / converted 全部持久化', () async {
      final item = await services.inbox
          .add(kind: InboxKind.quickTask, content: '临时任务 A');
      await services.inbox.updateContent(item.id, '临时任务 A（改）');
      final edited = await services.inbox.listOpen();
      expect(edited.single.content, '临时任务 A（改）');

      await services.inbox.setStatus(item.id, InboxStatus.archived);
      expect(await services.inbox.listOpen(), isEmpty);

      final item2 =
          await services.inbox.add(kind: InboxKind.idea, content: '想法 B');
      await services.inbox.delete(item2.id);
      expect(await services.inbox.listOpen(), isEmpty);
    });
  });

  group('InboxPage', () {
    Future<void> pumpInbox(WidgetTester tester, {String? waitFor}) async {
      await tester.pumpWidget(
          AppScope(services: services, child: const VeyraApp()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('收件箱'));
      await tester.pumpAndSettle();
      if (waitFor != null) {
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 100));
          if (find.text(waitFor).evaluate().isNotEmpty) break;
        }
        await tester.pumpAndSettle();
      }
    }

    testWidgets('快速记录 → 列表出现条目', (tester) async {
      await pumpInbox(tester);
      await tester.enterText(find.byType(TextField).first, '给训练记录补一页复盘');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('给训练记录补一页复盘'), findsOneWidget);
    });

    testWidgets('转入已有项目：任务出现在项目中，条目转为已处理', (tester) async {
      final project = await services.projects.createProject(title: '减脂计划');
      final phase = await services.projects.createPhase(project.id, '饮食与活动');
      await services.projects.createTask(
          projectId: project.id, phaseId: phase.id, title: '已有任务');
      await services.inbox
          .add(kind: InboxKind.quickTask, content: '整理用户访谈笔记');

      await pumpInbox(tester, waitFor: '整理用户访谈笔记');
      await tester.tap(find.text('移入项目'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('减脂计划'));
      await tester.pumpAndSettle();

      // 条目已转为已处理，从列表消失
      expect(find.text('整理用户访谈笔记'), findsNothing);
      // 项目里出现该任务
      final tasks = await services.projects.tasksOfProject(project.id);
      expect(tasks.map((t) => t.title), contains('整理用户访谈笔记'));
    });

    testWidgets('创建为新项目', (tester) async {
      await services.inbox.add(kind: InboxKind.newGoal, content: '三个月学完交互设计');
      await pumpInbox(tester);

      await tester.tap(find.text('创建为项目'));
      await tester.pumpAndSettle();

      final projects = await services.projects.listProjects();
      expect(projects.map((p) => p.title), contains('三个月学完交互设计'));
      expect(await services.inbox.listOpen(), isEmpty);
    });

    testWidgets('删除需要确认，确认后消失', (tester) async {
      await services.inbox.add(kind: InboxKind.quickTask, content: '要删掉的');
      await pumpInbox(tester);

      await tester.tap(find.text('删除').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除').last);
      await tester.pumpAndSettle();

      expect(find.text('要删掉的'), findsNothing);
    });

    testWidgets('归档后条目消失但数据仍在库中', (tester) async {
      await services.inbox.add(kind: InboxKind.idea, content: '先放一放的想法');
      await pumpInbox(tester);

      await tester.tap(find.text('归档'));
      await tester.pumpAndSettle();

      expect(find.text('先放一放的想法'), findsNothing);
      expect(
          (await services.inbox.listOpen()), isEmpty);
    });
  });
}
