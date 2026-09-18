/// Review 服务（Slice 2.8，PRD §9.6 Progress Story）。
///
/// 原则：成果优先，任务数量只是次要信息；复盘生成后存 ReviewSnapshot。
library;

import 'dart:convert';

import '../../core/domain/enums.dart';
import '../../core/utils/week.dart';
import '../../data/app_services.dart';
import 'ai_provider.dart';

/// 一份复盘的展示数据（成果优先的聚合视图）。
class ReviewStory {
  const ReviewStory({
    required this.completedCount,
    required this.highlights,
    required this.milestones,
    required this.deferred,
    this.aiSummary,
  });

  final int completedCount;
  final List<String> highlights;
  final List<String> milestones;
  final List<String> deferred;
  final String? aiSummary;
}

class ReviewService {
  ReviewService({required this.provider, required this.services});

  final AIProvider provider;
  final AppServices services;

  /// 本周复盘。
  Future<ReviewStory> weekReview({DateTime? weekStart}) async {
    final start = mondayOf(weekStart ?? DateTime.now());
    final end = start.add(const Duration(days: 7));
    final events = await services.progress.eventsBetween(start, end);

    final completed = [
      for (final e in events)
        if (e.type == ProgressEventType.taskCompleted) e.detail,
    ];
    final milestones = [
      for (final e in events)
        if (e.type == ProgressEventType.milestoneCompleted) e.detail,
    ];
    final deferred = [
      for (final e in events)
        if (e.type == ProgressEventType.taskDeferred) e.detail,
    ];

    // 成果：已完成任务的 outcomeNote（你最终完成了什么，PRD §12）。
    final highlights = <String>[];
    for (final project in await services.projects.listProjects()) {
      for (final task
          in await services.projects.tasksOfProject(project.id)) {
        if (task.isDone && task.outcomeNote != null) {
          highlights.add('${task.title}：${task.outcomeNote}');
        }
      }
    }

    final aiSummary = await provider.generateReview(AIReviewRequest(
      scopeDescription:
          '本周（${start.toIso8601String().substring(0, 10)} 起）',
      completedItems: completed,
      milestonesCompleted: milestones,
      deferredItems: deferred,
    ));

    await services.progress.saveSnapshot(
      scope: ReviewScope.week,
      periodStart: start,
      periodEnd: end,
      storyJson: jsonEncode({
        'completed': completed,
        'highlights': highlights,
        'milestones': milestones,
        'deferred': deferred,
      }),
      aiSummary: aiSummary.oneLineSummary,
    );

    return ReviewStory(
      completedCount: completed.length,
      highlights: highlights,
      milestones: milestones,
      deferred: deferred,
      aiSummary: aiSummary.oneLineSummary,
    );
  }

  /// 项目复盘。
  Future<ReviewStory> projectReview(int projectId) async {
    final project = await services.projects.getProject(projectId);
    if (project == null) throw AIException('项目不存在。');
    final tasks = await services.projects.tasksOfProject(projectId);
    final events = await services.progress.eventsOfProject(projectId);

    final completed = [
      for (final t in tasks)
        if (t.isDone) t.title,
    ];
    final highlights = [
      for (final t in tasks)
        if (t.isDone && t.outcomeNote != null) '${t.title}：${t.outcomeNote}',
    ];
    final milestones = [
      for (final m in await services.projects.milestonesOfProject(projectId))
        if (m.isCompleted) m.title,
    ];
    final deferred = [
      for (final e in events)
        if (e.type == ProgressEventType.taskDeferred) e.detail,
    ];

    final aiSummary = await provider.generateReview(AIReviewRequest(
      scopeDescription: '项目「${project.title}」',
      completedItems: completed,
      milestonesCompleted: milestones,
      deferredItems: deferred,
    ));

    final periodStart = project.startDate;
    await services.progress.saveSnapshot(
      scope: ReviewScope.project,
      targetId: projectId,
      periodStart: periodStart,
      periodEnd: DateTime.now(),
      storyJson: jsonEncode({
        'completed': completed,
        'highlights': highlights,
        'milestones': milestones,
        'deferred': deferred,
      }),
      aiSummary: aiSummary.oneLineSummary,
    );

    return ReviewStory(
      completedCount: completed.length,
      highlights: highlights,
      milestones: milestones,
      deferred: deferred,
      aiSummary: aiSummary.oneLineSummary,
    );
  }
}
