/// Replanner 服务（Slice 2.7，PRD §9.4）。
///
/// 现状收集 → AI 提出调整建议（草案）→ 用户确认前数据零改动 →
/// 全部应用 / 选择性应用（partial）→ 取消（rejected）。
library;

import 'dart:convert';

import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../../core/utils/week.dart';
import '../../data/app_services.dart';
import 'ai_provider.dart';
import 'plan_models.dart';

class ReplannerService {
  ReplannerService({required this.provider, required this.services});

  final AIProvider provider;
  final AppServices services;

  /// 收集本周现状并请求调整建议；结果只存为 Proposal 草稿。
  Future<AIProposal> proposeChanges({required String situation}) async {
    final weekStart = mondayOf(DateTime.now());
    final items = await services.week.weekItems(weekStart);
    final projects = await services.projects.listProjects();

    final currentWeek = StringBuffer();
    for (final (_, task, project) in items) {
      currentWeek.writeln(
          '${project.title} · ${task.title}（${task.priority == TaskPriority.must ? '必做' : '可选'}，'
          '${task.isDone ? '已完成' : '未完成'}）');
    }
    if (items.isEmpty) currentWeek.writeln('本周暂无安排');

    final deadlines = StringBuffer();
    for (final p in projects) {
      if (p.deadline != null) {
        deadlines.writeln('${p.title}：截止 ${p.deadline!.toIso8601String().substring(0, 10)}');
      }
    }

    final proposal = await provider.proposeRebalance(AIRebalanceRequest(
      situation: situation,
      currentWeekDescription: currentWeek.toString(),
      deadlineDescription:
          deadlines.isEmpty ? '没有设置截止日期' : deadlines.toString(),
      taskSummary: '共 ${items.length} 个任务在本周',
    ));

    return services.proposals.saveDraft(
      kind: 'rebalance',
      payloadJson: jsonEncode(proposal.toJson()),
      summary: proposal.summary,
    );
  }

  /// 应用选中的调整。全部应用 → accepted；部分应用 → partially_accepted。
  /// 返回实际应用的条数。取消请用 [cancel]。
  Future<int> applyChanges(int proposalId, {Set<int>? indexes}) async {
    final proposal = await services.proposals.get(proposalId);
    if (proposal == null) throw AIException('提案不存在。');
    if (proposal.isDecided) throw AIException('这份提案已经处理过了。');
    if (proposal.kind != 'rebalance') throw AIException('这不是重规划提案。');

    final rebalance = RebalanceProposal.fromJson(
        jsonDecode(proposal.payloadJson) as Map<String, dynamic>);
    final selected = indexes == null
        ? List<RebalanceChange>.generate(
            rebalance.changes.length, (i) => rebalance.changes[i])
        : [for (final i in indexes) rebalance.changes[i]];

    final weeklyProjects = [
      for (final p in await services.projects.listProjects())
        if (p.executionMode == ExecutionMode.weeklyPlanning) p,
    ];

    var applied = 0;
    for (final change in selected) {
      final task = await _findTask(change.taskTitle);
      switch (change.kind) {
        case RebalanceChangeKind.moveWeek:
          if (task == null) continue;
          if (!await _moveToNextWeek(task)) continue;
        case RebalanceChangeKind.priorityChange:
          if (task == null) continue;
          await services.projects.updateTask(task.copyWith(
            priority: task.priority == TaskPriority.must
                ? TaskPriority.optional
                : TaskPriority.must,
          ));
        case RebalanceChangeKind.defer:
          if (task == null) continue;
          await services.projects.setTaskStatus(task.id, TaskStatus.deferred);
        case RebalanceChangeKind.addTask:
          if (weeklyProjects.isEmpty) continue;
          Project? target;
          for (final p in weeklyProjects) {
            if (change.to != null && p.title == change.to) target = p;
          }
          target ??= weeklyProjects.first;
          final phase = await _firstOrCreatePhase(target);
          await services.projects.createTask(
            projectId: target.id,
            phaseId: phase.id,
            title: change.taskTitle,
            priority: TaskPriority.must,
          );
          await services.week.assignTaskToWeek(
            (await services.projects.tasksOfProject(target.id))
                .lastWhere((t) => t.title == change.taskTitle)
                .id,
          );
      }
      applied += 1;
      await services.progress.log(ProgressEventType.weekRebalanced,
          detail: change.detail.isEmpty ? change.taskTitle : change.detail);
    }

    await services.proposals.decide(
      proposalId,
      applied == rebalance.changes.length
          ? ProposalStatus.accepted
          : ProposalStatus.partiallyAccepted,
    );
    return applied;
  }

  /// 取消：状态改为 rejected，数据零改动。
  Future<void> cancel(int proposalId) async {
    final proposal = await services.proposals.get(proposalId);
    if (proposal == null || proposal.isDecided) return;
    await services.proposals.decide(proposalId, ProposalStatus.rejected);
  }

  // ---------- 内部 ----------

  Future<Task?> _findTask(String title) async {
    for (final project
        in await services.projects.listProjects(includeArchived: true)) {
      for (final task in await services.projects.tasksOfProject(project.id)) {
        if (task.title == title) return task;
      }
    }
    return null;
  }

  Future<bool> _moveToNextWeek(Task task) async {
    final weekStart = mondayOf(DateTime.now());
    final assignments = await services.week.assignmentsOfWeek(weekStart);
    final mine = assignments.where((a) => a.taskId == task.id).toList();
    if (mine.isEmpty) return false;
    await services.week.moveAssignment(
        mine.first.id, weekStart.add(const Duration(days: 7)));
    return true;
  }

  Future<Phase> _firstOrCreatePhase(Project project) async {
    final phases = await services.projects.phasesOfProject(project.id);
    if (phases.isNotEmpty) return phases.first;
    return services.projects.createPhase(project.id, '新情况');
  }
}
