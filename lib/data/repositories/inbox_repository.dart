/// Inbox 仓储（PRD §15 收件箱）。
library;

import 'package:drift/drift.dart';

import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../db/app_database.dart';

class InboxRepository {
  InboxRepository(this._db, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  InboxItem _toItem(InboxItemRow r) => InboxItem(
        id: r.id,
        kind: r.kind,
        content: r.content,
        filePath: r.filePath,
        status: r.status,
        createdAt: r.createdAt,
      );

  Future<InboxItem> add({
    required InboxKind kind,
    required String content,
    String? filePath,
  }) async {
    final id = await _db.into(_db.inboxItems).insert(InboxItemsCompanion.insert(
          kind: kind,
          content: content,
          filePath: Value(filePath),
          status: InboxStatus.open,
          createdAt: _now(),
        ));
    return _toItem(
        await (_db.select(_db.inboxItems)..where((t) => t.id.equals(id)))
            .getSingle());
  }

  Future<List<InboxItem>> listOpen() async {
    final rows = await (_db.select(_db.inboxItems)
          ..where((t) => t.status.equals(InboxStatus.open.name))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_toItem).toList();
  }

  Future<void> setStatus(int id, InboxStatus status) async {
    await (_db.update(_db.inboxItems)..where((t) => t.id.equals(id)))
        .write(InboxItemsCompanion(status: Value(status)));
  }

  Future<void> updateContent(int id, String content) async {
    await (_db.update(_db.inboxItems)..where((t) => t.id.equals(id)))
        .write(InboxItemsCompanion(content: Value(content)));
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.inboxItems)..where((t) => t.id.equals(id))).go();
  }
}
