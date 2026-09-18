/// Week ViewModel（Slice 2.6）：当前周的目标分组、容量、周归属管理。
library;

import 'package:flutter/foundation.dart';

import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../../core/utils/week.dart';
import '../../data/app_services.dart';

/// 一个项目在本周的目标分组（PRD §11.1：第一层只显示 2-5 个重点）。
class WeekGoalGroup {
  WeekGoalGroup({
    required this.project,
    required this.assignments,
    required this.tasks,
  });

  final Project project;
  final List<WeeklyAssignment> assignments;
  final List<Task> tasks;

  /// 本周重点：必做优先，最多 3 个标题。
  List<Task> get focusTasks {
    final open = tasks.where((t) => !t.isDone).toList()
      ..sort((a, b) {
        if (a.priority != b.priority) {
          return a.priority == TaskPriority.must ? -1 : 1;
        }
        return a.orderIndex.compareTo(b.orderIndex);
      });
    return open.take(3).toList();
  }

  bool get allDone => tasks.isNotEmpty && tasks.every((t) => t.isDone);
}

class WeekViewModel extends ChangeNotifier {
  WeekViewModel(this._services, {DateTime? now})
      : _now = now ?? DateTime.now();

  final AppServices _services;
  final DateTime _now;

  DateTime get currentWeekStart => mondayOf(_now);

  List<WeekGoalGroup> _groups = [];
  CapacityLevel _capacity = CapacityLevel.normal;
  bool _loading = false;
  String? _error;

  List<WeekGoalGroup> get groups => _groups;
  CapacityLevel get capacity => _capacity;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> refresh() async {
    _loading = true;
    notifyListeners();
    try {
      final items = await _services.week.weekItems(currentWeekStart);
      final byProject = <int, WeekGoalGroup>{};
      for (final (assignment, task, project) in items) {
        byProject.putIfAbsent(
            project.id,
            () => WeekGoalGroup(
                project: project, assignments: [], tasks: []));
        byProject[project.id]!.assignments.add(assignment);
        byProject[project.id]!.tasks.add(task);
      }
      _groups = byProject.values.toList();
      _capacity = await _services.week.capacityOf(currentWeekStart);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> setCapacity(CapacityLevel level) async {
    await _services.week.setCapacity(currentWeekStart, level);
    _capacity = level;
    notifyListeners();
  }

  /// 把任务加入本周（Project Only 会被仓储层拒绝）。
  Future<bool> addTaskToWeek(int taskId) async {
    final ok = await _services.week.assignTaskToWeek(
      taskId,
      week: currentWeekStart,
    );
    await refresh();
    return ok;
  }

  Future<void> removeAssignment(int assignmentId) async {
    await _services.week.moveAssignment(
        assignmentId, currentWeekStart.add(const Duration(days: 7)));
    await refresh();
  }

  Future<void> completeTask(int taskId) async {
    await _services.projects.completeTask(taskId);
    await refresh();
  }

  /// 可加入本周的任务：仅 Weekly 项目的未完成任务，且未在本周。
  Future<List<(Task, Project)>> availableTasks() async {
    final projects = await _services.projects.listProjects();
    final assigned = _groups.fold<Set<int>>({}, (set, g) {
      set.addAll(g.tasks.map((t) => t.id));
      return set;
    });
    final result = <(Task, Project)>[];
    for (final project in projects) {
      if (project.executionMode != ExecutionMode.weeklyPlanning) continue;
      final tasks = await _services.projects.tasksOfProject(project.id);
      for (final task in tasks) {
        if (task.isDone || assigned.contains(task.id)) continue;
        result.add((task, project));
      }
    }
    return result;
  }
}
