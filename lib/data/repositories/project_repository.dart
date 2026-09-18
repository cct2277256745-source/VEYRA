/// Project 聚合仓储：Project / Phase / Milestone / Task / 依赖 / 来源引用。
///
/// 同时负责把操作写入 ProgressEvent（Progress Story 的原始轨迹）。
library;

import 'package:drift/drift.dart';

import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../db/app_database.dart';

class ProjectRepository {
  ProjectRepository(this._db, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  // ---------- 映射 ----------

  Project _toProject(ProjectsRow r) => Project(
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

  Phase _toPhase(PhasesRow r) => Phase(
        id: r.id,
        projectId: r.projectId,
        title: r.title,
        goal: r.goal,
        orderIndex: r.orderIndex,
        createdAt: r.createdAt,
      );

  Milestone _toMilestone(MilestonesRow r) => Milestone(
        id: r.id,
        projectId: r.projectId,
        phaseId: r.phaseId,
        title: r.title,
        orderIndex: r.orderIndex,
        createdAt: r.createdAt,
        completedAt: r.completedAt,
      );

  Task _toTask(TasksRow r) => Task(
        id: r.id,
        projectId: r.projectId,
        phaseId: r.phaseId,
        milestoneId: r.milestoneId,
        title: r.title,
        description: r.description,
        status: r.status,
        priority: r.priority,
        effort: r.effort,
        dueDate: r.dueDate,
        sourceRefId: r.sourceRefId,
        outcomeNote: r.outcomeNote,
        userNote: r.userNote,
        orderIndex: r.orderIndex,
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
      );

  // ---------- Project ----------

  Future<Project> createProject({
    required String title,
    String outcome = '',
    ExecutionMode executionMode = ExecutionMode.projectOnly,
    DateTime? deadline,
    int? themeColor,
    int? sourceDocumentId,
  }) async {
    final now = _now();
    final id = await _db.into(_db.projects).insert(ProjectsCompanion.insert(
          title: title,
          outcome: Value(outcome),
          executionMode: executionMode,
          status: ProjectStatus.active,
          health: PlanHealth.onTrack,
          startDate: now,
          deadline: Value(deadline),
          themeColor: Value(themeColor),
          sourceDocumentId: Value(sourceDocumentId),
          createdAt: now,
          updatedAt: now,
        ));
    await _log(ProgressEventType.projectCreated, projectId: id, detail: title);
    return (await getProject(id))!;
  }

  Future<Project?> getProject(int id) async {
    final row =
        await (_db.select(_db.projects)..where((t) => t.id.equals(id)))
            .getSingleOrNull();
    return row == null ? null : _toProject(row);
  }

  Future<List<Project>> listProjects({bool includeArchived = false}) async {
    final query = _db.select(_db.projects);
    if (!includeArchived) {
      query.where((t) => t.status.isIn([
        ProjectStatus.active.name,
        ProjectStatus.paused.name,
        ProjectStatus.completed.name,
      ]));
    }
    final rows = await query.get();
    return rows.map(_toProject).toList();
  }

  Stream<List<Project>> watchProjects({bool includeArchived = false}) {
    final query = _db.select(_db.projects);
    if (!includeArchived) {
      query.where((t) => t.status.isIn([
        ProjectStatus.active.name,
        ProjectStatus.paused.name,
        ProjectStatus.completed.name,
      ]));
    }
    return query.watch().map((rows) => rows.map(_toProject).toList());
  }

  Future<void> updateProject(Project project) async {
    await (_db.update(_db.projects)..where((t) => t.id.equals(project.id)))
        .write(ProjectsCompanion(
      title: Value(project.title),
      outcome: Value(project.outcome),
      executionMode: Value(project.executionMode),
      status: Value(project.status),
      health: Value(project.health),
      deadline: Value(project.deadline),
      themeColor: Value(project.themeColor),
      updatedAt: Value(_now()),
    ));
  }

  Future<void> setProjectStatus(int projectId, ProjectStatus status) async {
    await (_db.update(_db.projects)..where((t) => t.id.equals(projectId)))
        .write(ProjectsCompanion(
      status: Value(status),
      updatedAt: Value(_now()),
    ));
    await _log(ProgressEventType.projectStatusChanged,
        projectId: projectId, detail: status.name);
  }

  Future<void> setExecutionMode(int projectId, ExecutionMode mode) async {
    final project = await getProject(projectId);
    if (project == null) return;
    await updateProject(project.copyWith(executionMode: mode));
    // 切回 Project Only 时，其周归属全部失效（Week 是可选投影）。
    if (mode == ExecutionMode.projectOnly) {
      await (_db.delete(_db.weeklyAssignments)
            ..where((t) => t.projectId.equals(projectId)))
          .go();
    }
  }

  // ---------- Phase / Milestone ----------

  Future<Phase> createPhase(int projectId, String title, {String? goal}) async {
    final existing = await (_db.select(_db.phases)
          ..where((t) => t.projectId.equals(projectId)))
        .get();
    final now = _now();
    final id = await _db.into(_db.phases).insert(PhasesCompanion.insert(
          projectId: projectId,
          title: title,
          goal: Value(goal),
          orderIndex: existing.length,
          createdAt: now,
        ));
    return _toPhase(
        await (_db.select(_db.phases)..where((t) => t.id.equals(id)))
            .getSingle());
  }

  Future<Milestone> createMilestone(int phaseId, String title) async {
    final phase = await (_db.select(_db.phases)
          ..where((t) => t.id.equals(phaseId)))
        .getSingle();
    final siblings = await (_db.select(_db.milestones)
          ..where((t) => t.phaseId.equals(phaseId)))
        .get();
    final now = _now();
    final id = await _db.into(_db.milestones).insert(MilestonesCompanion.insert(
          projectId: phase.projectId,
          phaseId: phaseId,
          title: title,
          orderIndex: siblings.length,
          createdAt: now,
        ));
    return _toMilestone(
        await (_db.select(_db.milestones)..where((t) => t.id.equals(id)))
            .getSingle());
  }

  Future<void> completeMilestone(int milestoneId) async {
    await (_db.update(_db.milestones)
          ..where((t) => t.id.equals(milestoneId)))
        .write(MilestonesCompanion(completedAt: Value(_now())));
    final m = await (_db.select(_db.milestones)
          ..where((t) => t.id.equals(milestoneId)))
        .getSingle();
    await _log(ProgressEventType.milestoneCompleted,
        projectId: m.projectId, detail: m.title);
  }

  // ---------- Task ----------

  Future<Task> createTask({
    required int projectId,
    required int phaseId,
    required String title,
    int? milestoneId,
    String? description,
    TaskPriority priority = TaskPriority.optional,
    EstimatedEffort effort = EstimatedEffort.medium,
    DateTime? dueDate,
    int? sourceRefId,
  }) async {
    final siblings = await (_db.select(_db.tasks)
          ..where((t) => t.phaseId.equals(phaseId)))
        .get();
    final now = _now();
    final id = await _db.into(_db.tasks).insert(TasksCompanion.insert(
          projectId: projectId,
          phaseId: phaseId,
          milestoneId: Value(milestoneId),
          title: title,
          description: Value(description),
          status: TaskStatus.planned,
          priority: priority,
          effort: effort,
          dueDate: Value(dueDate),
          sourceRefId: Value(sourceRefId),
          orderIndex: siblings.length,
          createdAt: now,
          updatedAt: now,
        ));
    return _toTask(
        await (_db.select(_db.tasks)..where((t) => t.id.equals(id)))
            .getSingle());
  }

  Future<Task?> getTask(int id) async {
    final row = await (_db.select(_db.tasks)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toTask(row);
  }

  Future<List<Phase>> phasesOfProject(int projectId) async {
    final rows = await (_db.select(_db.phases)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
    return rows.map(_toPhase).toList();
  }

  Future<List<Milestone>> milestonesOfProject(int projectId) async {
    final rows = await (_db.select(_db.milestones)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.phaseId), (t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
    return rows.map(_toMilestone).toList();
  }

  Future<List<Task>> tasksOfProject(int projectId) async {
    final rows = await (_db.select(_db.tasks)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.phaseId), (t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
    return rows.map(_toTask).toList();
  }

  Future<void> updateTask(Task task) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(task.id)))
        .write(TasksCompanion(
      title: Value(task.title),
      description: Value(task.description),
      status: Value(task.status),
      priority: Value(task.priority),
      effort: Value(task.effort),
      dueDate: Value(task.dueDate),
      outcomeNote: Value(task.outcomeNote),
      userNote: Value(task.userNote),
      orderIndex: Value(task.orderIndex),
      updatedAt: Value(_now()),
    ));
  }

  /// 完成任务并记录事件；可附完成成果（PRD §12）。
  Future<void> completeTask(int taskId, {String? outcomeNote}) async {
    final task = await getTask(taskId);
    if (task == null || task.isDone) return;
    await updateTask(
        task.copyWith(status: TaskStatus.completed, outcomeNote: outcomeNote));
    await _log(ProgressEventType.taskCompleted,
        projectId: task.projectId, taskId: taskId, detail: task.title);
  }

  Future<void> setTaskStatus(int taskId, TaskStatus status) async {
    final task = await getTask(taskId);
    if (task == null) return;
    await updateTask(task.copyWith(status: status));
    if (status == TaskStatus.deferred) {
      await _log(ProgressEventType.taskDeferred,
          projectId: task.projectId, taskId: taskId, detail: task.title);
    } else if (status == TaskStatus.skipped) {
      await _log(ProgressEventType.taskSkipped,
          projectId: task.projectId, taskId: taskId, detail: task.title);
    }
  }

  /// 删除任务；若有其他任务依赖它，抛出 StateError（PRD §22 失败场景）。
  Future<void> deleteTask(int taskId) async {
    final blockers = await (_db.select(_db.taskDependencies)
          ..where((t) => t.dependsOnTaskId.equals(taskId)))
        .get();
    if (blockers.isNotEmpty) {
      throw StateError('task $taskId is depended on by ${blockers.length} tasks');
    }
    await (_db.delete(_db.taskDependencies)
          ..where((t) => t.taskId.equals(taskId)))
        .go();
    await (_db.delete(_db.weeklyAssignments)
          ..where((t) => t.taskId.equals(taskId)))
        .go();
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(taskId))).go();
  }

  // ---------- 依赖 ----------

  Future<void> addDependency(int taskId, int dependsOnTaskId) async {
    if (taskId == dependsOnTaskId) return;
    final existing = await (_db.select(_db.taskDependencies)
          ..where((t) =>
              t.taskId.equals(taskId) &
              t.dependsOnTaskId.equals(dependsOnTaskId)))
        .getSingleOrNull();
    if (existing != null) return;
    await _db.into(_db.taskDependencies).insert(
        TaskDependenciesCompanion.insert(
            taskId: taskId, dependsOnTaskId: dependsOnTaskId));
  }

  Future<List<TaskDependency>> dependenciesOfTask(int taskId) async {
    final rows = await (_db.select(_db.taskDependencies)
          ..where((t) => t.taskId.equals(taskId)))
        .get();
    return rows
        .map((r) => TaskDependency(
            taskId: r.taskId, dependsOnTaskId: r.dependsOnTaskId))
        .toList();
  }

  // ---------- 来源引用 ----------

  Future<SourceRef> createSourceRef({
    required SourceKind kind,
    required String quote,
    String aiReason = '',
    int? documentId,
  }) async {
    final id = await _db.into(_db.sourceRefs).insert(SourceRefsCompanion.insert(
          kind: kind,
          quote: quote,
          aiReason: Value(aiReason),
          documentId: Value(documentId),
          createdAt: _now(),
        ));
    final row = await (_db.select(_db.sourceRefs)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return SourceRef(
      id: row.id,
      kind: row.kind,
      quote: row.quote,
      aiReason: row.aiReason,
      documentId: row.documentId,
      createdAt: row.createdAt,
    );
  }

  Future<SourceRef?> getSourceRef(int id) async {
    final row = await (_db.select(_db.sourceRefs)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return SourceRef(
      id: row.id,
      kind: row.kind,
      quote: row.quote,
      aiReason: row.aiReason,
      documentId: row.documentId,
      createdAt: row.createdAt,
    );
  }

  // ---------- 内部 ----------

  Future<void> _log(ProgressEventType type,
      {int? projectId, int? taskId, String detail = ''}) async {
    await _db.into(_db.progressEvents).insert(ProgressEventsCompanion.insert(
          type: type,
          projectId: Value(projectId),
          taskId: Value(taskId),
          detail: Value(detail),
          occurredAt: _now(),
        ));
  }
}
