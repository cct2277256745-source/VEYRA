// 端到端验证：DB(Base URL/Model) + Keychain(Key) → 真实连通 GLM。
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:veyra/ai/ai_provider_factory.dart';
import 'package:veyra/ai/secure_key_store.dart';
import 'package:veyra/data/db/app_database.dart';
import 'package:veyra/ai/openai_compatible_provider.dart';
import 'package:veyra/data/repositories/ai_settings_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('生产配置端到端连通', (tester) async {
    final db = AppDatabase.openFile(AppDatabase.defaultDatabaseFile());
    final settings = AiSettingsRepository(db);
    final factory = AIProviderFactory(
      settings: settings,
      keyStore: SecureStorageKeyStore(),
    );

    expect(await factory.isConfigured(), isTrue,
        reason: 'DB 与 Keychain 中的配置应齐备');
    final provider = await factory.createOrNull();
    expect(provider, isNotNull,
        reason: '生产环境必须拿到真实 Provider，而非 Mock');

    // 真实连通（不再写死任何配置，全部来自本机存储）
    final openAi = provider as OpenAICompatibleProvider;
    await openAi.testConnection();
    await db.close();
  });
}
