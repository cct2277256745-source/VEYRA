/// 进度事件与复盘快照仓储（Progress Story / Review 的数据来源）。
library;

import 'package:drift/drift.dart';

import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../db/app_database.dart';

class ProgressRepository {
  ProgressRepository(this._db, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  ProgressEvent _toEvent(ProgressEventRow r) => ProgressEvent(
        id: r.id,
        type: r.type,
        projectId: r.projectId,
        taskId: r.taskId,
        detail: r.detail,
        occurredAt: r.occurredAt,
      );

  ReviewSnapshot _toSnapshot(ReviewSnapshotRow r) => ReviewSnapshot(
        id: r.id,
        scope: r.scope,
        targetId: r.targetId,
        periodStart: r.periodStart,
        periodEnd: r.periodEnd,
        storyJson: r.storyJson,
        aiSummary: r.aiSummary,
        createdAt: r.createdAt,
      );

  Future<ProgressEvent> log(
    ProgressEventType type, {
    int? projectId,
    int? taskId,
    String detail = '',
    DateTime? occurredAt,
  }) async {
    final id =
        await _db.into(_db.progressEvents).insert(ProgressEventsCompanion.insert(
              type: type,
              projectId: Value(projectId),
              taskId: Value(taskId),
              detail: Value(detail),
              occurredAt: occurredAt ?? _now(),
            ));
    return _toEvent(
        await (_db.select(_db.progressEvents)..where((t) => t.id.equals(id)))
            .getSingle());
  }

  Future<List<ProgressEvent>> eventsOfProject(int projectId) async {
    final rows = await (_db.select(_db.progressEvents)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
        .get();
    return rows.map(_toEvent).toList();
  }

  Future<List<ProgressEvent>> eventsBetween(DateTime start, DateTime end) async {
    final rows = await (_db.select(_db.progressEvents)
          ..where((t) =>
              t.occurredAt.isBiggerOrEqualValue(start) &
              t.occurredAt.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
        .get();
    return rows.map(_toEvent).toList();
  }

  Future<ReviewSnapshot> saveSnapshot({
    required ReviewScope scope,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String storyJson,
    int? targetId,
    String? aiSummary,
  }) async {
    final id = await _db
        .into(_db.reviewSnapshots)
        .insert(ReviewSnapshotsCompanion.insert(
          scope: scope,
          targetId: Value(targetId),
          periodStart: periodStart,
          periodEnd: periodEnd,
          storyJson: storyJson,
          aiSummary: Value(aiSummary),
          createdAt: _now(),
        ));
    return _toSnapshot(
        await (_db.select(_db.reviewSnapshots)..where((t) => t.id.equals(id)))
            .getSingle());
  }

  Future<ReviewSnapshot?> latestWeekSnapshot(DateTime weekStart) async {
    final rows = await (_db.select(_db.reviewSnapshots)
          ..where((t) =>
              t.scope.equals(ReviewScope.week.name) &
              t.periodStart.equals(weekStart))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.isEmpty ? null : _toSnapshot(rows.first);
  }

  Future<ReviewSnapshot?> latestProjectSnapshot(int projectId) async {
    final rows = await (_db.select(_db.reviewSnapshots)
          ..where((t) =>
              t.scope.equals(ReviewScope.project.name) &
              t.targetId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.isEmpty ? null : _toSnapshot(rows.first);
  }
}
