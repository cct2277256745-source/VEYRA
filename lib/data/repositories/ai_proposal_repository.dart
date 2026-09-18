/// AI Proposal 仓储：提案只有走完用户决定流程才改变状态（PRD §21）。
library;

import 'package:drift/drift.dart';

import '../../core/domain/enums.dart';
import '../../core/domain/entities.dart';
import '../db/app_database.dart';

class AiProposalRepository {
  AiProposalRepository(this._db, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  AIProposal _toProposal(AiProposalRow r) => AIProposal(
        id: r.id,
        kind: r.kind,
        status: r.status,
        payloadJson: r.payloadJson,
        summary: r.summary,
        createdAt: r.createdAt,
        decidedAt: r.decidedAt,
      );

  /// 保存草稿。payload 必须是校验通过后的结构化 JSON 文本。
  Future<AIProposal> saveDraft({
    required String kind,
    required String payloadJson,
    required String summary,
  }) async {
    final id =
        await _db.into(_db.aiProposals).insert(AiProposalsCompanion.insert(
              kind: kind,
              status: ProposalStatus.draft,
              payloadJson: payloadJson,
              summary: summary,
              createdAt: _now(),
            ));
    return _toProposal(
        await (_db.select(_db.aiProposals)..where((t) => t.id.equals(id)))
            .getSingle());
  }

  Future<AIProposal?> get(int id) async {
    final row = await (_db.select(_db.aiProposals)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toProposal(row);
  }

  Future<void> decide(int id, ProposalStatus status) async {
    assert(status != ProposalStatus.draft);
    await (_db.update(_db.aiProposals)..where((t) => t.id.equals(id)))
        .write(AiProposalsCompanion(
      status: Value(status),
      decidedAt: Value(_now()),
    ));
  }

  Future<List<AIProposal>> undecided() async {
    final rows = await (_db.select(_db.aiProposals)
          ..where((t) => t.status.equals(ProposalStatus.draft.name))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_toProposal).toList();
  }
}
