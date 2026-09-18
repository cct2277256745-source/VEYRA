import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:veyra/core/domain/enums.dart';
import 'package:veyra/data/app_services.dart';

/// Slice 2.1 核心验收：新建 Project → 关闭 → 重新打开 → 数据仍在。
void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('veyra_db_test');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test('文件数据库：关闭后重开，Project / Task / 容量 / 收件箱全部还在', () async {
    final dbFile = File('${tempDir.path}/veyra.sqlite3');

    // —— 第一次“运行” —— //
    final first = AppServices.openFile(dbFile);
    final project = await first.projects.createProject(
      title: '健身 12 周计划',
      outcome: '完成 12 周训练',
      executionMode: ExecutionMode.weeklyPlanning,
    );
    final phase = await first.projects.createPhase(project.id, '训练记录');
    final task = await first.projects.createTask(
      projectId: project.id,
      phaseId: phase.id,
      title: '完成训练记录',
      priority: TaskPriority.must,
    );
    await first.week.assignTaskToWeek(task.id);
    await first.week.setCapacity(DateTime.now(), CapacityLevel.busy);
    await first.inbox.add(kind: InboxKind.quickTask, content: '周五完成 3 组训练');
    await first.close();

    // —— 第二次“运行”（模拟 App 重启） —— //
    final second = AppServices.openFile(dbFile);
    final loaded = await second.projects.getProject(project.id);
    expect(loaded, isNotNull);
    expect(loaded!.title, '健身 12 周计划');

    final tasks = await second.projects.tasksOfProject(project.id);
    expect(tasks.single.title, '完成训练记录');

    final weekItems = await second.week.weekItems(DateTime.now());
    expect(weekItems.single.$2.id, task.id);

    expect(await second.week.capacityOf(DateTime.now()), CapacityLevel.busy);
    expect(await second.inbox.listOpen(), hasLength(1));

    await second.close();
  });
}
