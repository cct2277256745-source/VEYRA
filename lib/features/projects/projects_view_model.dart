/// Projects 列表 ViewModel（Slice 2.2）。
library;

import 'package:flutter/foundation.dart';

import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../../data/app_services.dart';
import '../../core/design/progress_path.dart';
import 'project_progress.dart';

class ProjectsViewModel extends ChangeNotifier {
  ProjectsViewModel(this._services);

  final AppServices _services;
  List<Project> _projects = [];
  List<Project> _archivedProjects = [];
  Map<int, String> _nextStepByProject = {};
  Map<int, String> _currentPhaseByProject = {};
  Map<int, List<ProgressPathNode>> _pathByProject = {};
  Map<int, double> _progressByProject = {};
  bool _loading = false;
  String? _error;

  List<Project> get projects => _projects;
  List<Project> get archivedProjects => _archivedProjects;
  String? nextStepOf(int projectId) => _nextStepByProject[projectId];
  String? currentPhaseOf(int projectId) => _currentPhaseByProject[projectId];
  List<ProgressPathNode> pathOf(int projectId) =>
      _pathByProject[projectId] ?? const [];
  double progressOf(int projectId) => _progressByProject[projectId] ?? 0;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> refresh() async {
    _loading = true;
    notifyListeners();
    try {
      _projects = await _services.projects.listProjects();
      _archivedProjects =
          await _services.projects.listProjects(includeArchived: true);
      _archivedProjects = _archivedProjects
          .where((p) => p.status == ProjectStatus.archived)
          .toList();
      _nextStepByProject = {};
      _currentPhaseByProject = {};
      _pathByProject = {};
      _progressByProject = {};
      for (final p in [..._projects, ..._archivedProjects]) {
        final phases = await _services.projects.phasesOfProject(p.id);
        final tasks = await _services.projects.tasksOfProject(p.id);
        final open =
            tasks.where((t) => !t.isDone && t.status != TaskStatus.skipped);
        _progressByProject[p.id] = ProjectProgress.ratio(tasks);
        _currentPhaseByProject[p.id] =
            ProjectProgress.currentPhase(phases, tasks)?.title ?? '';
        _pathByProject[p.id] = ProjectProgress.pathNodes(phases, tasks);
        final next = _pickNext(open);
        _nextStepByProject[p.id] = next?.title ?? '';
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// 下一步：必做优先，其次有截止日的更靠前（Focus View / 项目卡共用）。
  static Task? _pickNext(Iterable<Task> open) {
    final list = open.toList()
      ..sort((a, b) {
        if (a.priority != b.priority) {
          return a.priority == TaskPriority.must ? -1 : 1;
        }
        final ad = a.dueDate, bd = b.dueDate;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return ad.compareTo(bd);
      });
    return list.isEmpty ? null : list.first;
  }

  static List<Task> pickFocusTasks(Iterable<Task> open, {int limit = 3}) {
    final list = open.toList()
      ..sort((a, b) {
        if (a.priority != b.priority) {
          return a.priority == TaskPriority.must ? -1 : 1;
        }
        final ad = a.dueDate, bd = b.dueDate;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return ad.compareTo(bd);
      });
    return list.take(limit).toList();
  }

  Future<void> archiveProject(int projectId) async {
    await _services.projects.setProjectStatus(projectId, ProjectStatus.archived);
    await refresh();
  }

  Future<void> restoreProject(int projectId) async {
    await _services.projects.setProjectStatus(projectId, ProjectStatus.active);
    await refresh();
  }

  Future<Project> createProject({
    required String title,
    String outcome = '',
    ExecutionMode executionMode = ExecutionMode.projectOnly,
  }) async {
    final project = await _services.projects.createProject(
      title: title,
      outcome: outcome,
      executionMode: executionMode,
    );
    await refresh();
    return project;
  }
}
