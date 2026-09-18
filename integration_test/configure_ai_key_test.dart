// 一次性配置工具：把用户提供的 API Key 写入本机 Keychain（系统安全存储）。
// Key 从环境变量 AI_KEY 读取，绝不写入仓库或数据库。
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:veyra/ai/ai_provider_factory.dart';
import 'package:veyra/ai/secure_key_store.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('写入并读回 API Key', (tester) async {
    final key = const String.fromEnvironment('AI_KEY');
    expect(key, isNotEmpty, reason: '需要 --dart-define=AI_KEY=...');

    final store = SecureStorageKeyStore();
    await store.write(AIProviderFactory.apiKeySettingKey, key);
    final readBack =
        await store.read(AIProviderFactory.apiKeySettingKey);
    expect(readBack, key);
  });
}
