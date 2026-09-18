/// Week 仓储：容量设置与周归属。
///
/// 硬规则（PRD §5.1/§11/AGENTS §4）：Project Only 项目不得进入 Week。
/// 本仓储在写入侧强制该规则，UI 层不需要重复判断。
library;

import 'package:drift/drift.dart';

import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../../core/utils/week.dart';
import '../db/app_database.dart';

class WeekRepository {
  WeekRepository(this._db, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

    WeeklyAssignment _toAssignment(WeeklyAssignmentRow r) => WeeklyAssignment(
        id: r.id,
        weekStart: r.weekStart,
        taskId: r.taskId,
        projectId: r.projectId,
        addedAt: r.addedAt,
      );

  // ---------- 容量 ----------

  Future<CapacityLevel> capacityOf(DateTime weekStart) async {
    final monday = mondayOf(weekStart);
    final row = await (_db.select(_db.weekSettings)
          ..where((t) => t.weekStart.equals(monday)))
        .getSingleOrNull();
    return row?.capacity ?? CapacityLevel.normal;
  }

  Future<void> setCapacity(DateTime weekStart, CapacityLevel capacity) async {
    final monday = mondayOf(weekStart);
    final existing = await (_db.select(_db.weekSettings)
          ..where((t) => t.weekStart.equals(monday)))
        .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.weekSettings).insert(WeekSettingsCompanion.insert(weekStart: monday, capacity: capacity));
    } else {
      await (_db.update(_db.weekSettings)
            ..where((t) => t.id.equals(existing.id)))
          .write(WeekSettingsCompanion(capacity: Value(capacity)));
    }
  }

  // ---------- 周归属 ----------

  /// 把任务加入某一周。Project Only 项目会被拒绝（返回 false）。
  Future<bool> assignTaskToWeek(int taskId, {DateTime? week}) async {
    final task = await (_db.select(_db.tasks)
          ..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (task == null) return false;
    final project = await (_db.select(_db.projects)
          ..where((t) => t.id.equals(task.projectId)))
        .getSingle();
    if (project.executionMode != ExecutionMode.weeklyPlanning) {
      return false;
    }
    final monday = mondayOf(week ?? _now());
    final dup = await (_db.select(_db.weeklyAssignments)
          ..where((t) =>
              t.taskId.equals(taskId) & t.weekStart.equals(monday)))
        .getSingleOrNull();
    if (dup != null) return true;
    await _db
        .into(_db.weeklyAssignments)
        .insert(WeeklyAssignmentsCompanion.insert(
          weekStart: monday,
          taskId: taskId,
          projectId: task.projectId,
          addedAt: _now(),
        ));
    return true;
  }

  Future<void> unassignTaskFromWeek(int taskId, DateTime weekStart) async {
    await (_db.delete(_db.weeklyAssignments)
          ..where((t) =>
              t.taskId.equals(taskId) &
              t.weekStart.equals(mondayOf(weekStart))))
        .go();
  }

  /// 移动周归属：只改 WeeklyAssignment，不复制 Task（PRD §21）。
  Future<void> moveAssignment(int assignmentId, DateTime toWeekStart) async {
    await (_db.update(_db.weeklyAssignments)
          ..where((t) => t.id.equals(assignmentId)))
        .write(WeeklyAssignmentsCompanion(
            weekStart: Value(mondayOf(toWeekStart))));
  }

  Future<List<WeeklyAssignment>> assignmentsOfWeek(DateTime weekStart) async {
    final monday = mondayOf(weekStart);
    final rows = await (_db.select(_db.weeklyAssignments)
          ..where((t) => t.weekStart.equals(monday)))
        .get();
    return rows.map(_toAssignment).toList();
  }

  /// 某一周的完整视图：分配的任务及其所属项目。
  Future<List<(WeeklyAssignment, Task, Project)>> weekItems(
      DateTime weekStart) async {
    final assignments = await assignmentsOfWeek(weekStart);
    final result = <(WeeklyAssignment, Task, Project)>[];
    for (final a in assignments) {
      final taskRow = await (_db.select(_db.tasks)
            ..where((t) => t.id.equals(a.taskId)))
          .getSingleOrNull();
      final projectRow = await (_db.select(_db.projects)
            ..where((t) => t.id.equals(a.projectId)))
          .getSingleOrNull();
      if (taskRow == null || projectRow == null) continue;
      result.add((
        a,
        Task(
          id: taskRow.id,
          projectId: taskRow.projectId,
          phaseId: taskRow.phaseId,
          milestoneId: taskRow.milestoneId,
          title: taskRow.title,
          description: taskRow.description,
          status: taskRow.status,
          priority: taskRow.priority,
          effort: taskRow.effort,
          dueDate: taskRow.dueDate,
          sourceRefId: taskRow.sourceRefId,
          outcomeNote: taskRow.outcomeNote,
          userNote: taskRow.userNote,
          orderIndex: taskRow.orderIndex,
          createdAt: taskRow.createdAt,
          updatedAt: taskRow.updatedAt,
        ),
        _toProjectRow(projectRow),
      ));
    }
    return result;
  }

  Project _toProjectRow(ProjectsRow r) => Project(
        id: r.id,
        title: r.title,
        outcome: r.outcome,
        executionMode: r.executionMode,
        status: r.status,
        health: r.health,
        startDate: r.startDate,
        deadline: r.deadline,
        themeColor: r.themeColor,
        sourceDocumentId: r.sourceDocumentId,
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
      );
}
