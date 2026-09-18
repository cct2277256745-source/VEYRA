/// AI 设置仓储：Base URL / Model 等非敏感配置存本地 Settings 表。
/// API Key 永远不进这里（只进 SecureKeyStore）。
library;

import '../db/app_database.dart';

class AiSettingsRepository {
  AiSettingsRepository(this._db);

  final AppDatabase _db;

  static const baseUrlKey = 'ai.baseUrl';
  static const modelKey = 'ai.model';

  Future<String?> get(String key) async {
    final row = await (_db.select(_db.settings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> set(String key, String value) async {
    await _db.into(_db.settings).insertOnConflictUpdate(
          SettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<void> remove(String key) async {
    await (_db.delete(_db.settings)..where((t) => t.key.equals(key))).go();
  }
}
