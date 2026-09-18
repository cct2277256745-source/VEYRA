/// SourceDocument 仓储：导入的规划文件（保留原文件名，PRD §18）。
library;

import 'package:drift/drift.dart';

import '../../core/domain/entities.dart';
import '../db/app_database.dart';

class SourceDocumentRepository {
  SourceDocumentRepository(this._db, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  SourceDocument _toDocument(SourceDocumentRow r) => SourceDocument(
        id: r.id,
        fileName: r.fileName,
        fileKind: r.fileKind,
        filePath: r.filePath,
        extractedText: r.extractedText,
        importedAt: r.importedAt,
      );

  Future<SourceDocument> create({
    required String fileName,
    required String fileKind,
    required String? extractedText,
    String? filePath,
  }) async {
    final id = await _db
        .into(_db.sourceDocuments)
        .insert(SourceDocumentsCompanion.insert(
          fileName: fileName,
          fileKind: fileKind,
          filePath: Value(filePath),
          extractedText: Value(extractedText),
          importedAt: _now(),
        ));
    return _toDocument(
        await (_db.select(_db.sourceDocuments)..where((t) => t.id.equals(id)))
            .getSingle());
  }

  Future<SourceDocument?> getByName(String name) async {
    final rows = await (_db.select(_db.sourceDocuments)
          ..where((t) => t.fileName.equals(name))
          ..orderBy([(t) => OrderingTerm.desc(t.importedAt)]))
        .get();
    return rows.isEmpty ? null : _toDocument(rows.first);
  }

  Future<SourceDocument?> get(int id) async {
    final row = await (_db.select(_db.sourceDocuments)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDocument(row);
  }
}
