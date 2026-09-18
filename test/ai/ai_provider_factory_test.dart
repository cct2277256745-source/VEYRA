import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veyra/ai/ai_provider.dart';
import 'package:veyra/ai/ai_provider_factory.dart';
import 'package:veyra/ai/mock_ai_provider.dart';
import 'package:veyra/ai/openai_compatible_provider.dart';
import 'package:veyra/ai/secure_key_store.dart';
import 'package:veyra/data/app_services.dart';
import 'package:veyra/data/repositories/ai_settings_repository.dart';

/// Phase 2.10：生产环境不允许静默使用 Mock。
void main() {
  late AppServices services;
  late InMemoryKeyStore keyStore;
  late AIProviderFactory factory;

  setUp(() {
    services = AppServices.inMemory();
    keyStore = InMemoryKeyStore();
    factory = AIProviderFactory(settings: services.aiSettings, keyStore: keyStore);
  });

  tearDown(() => services.close());

  test('未配置：createOrNull 返回 null（绝不静默 Mock）', () async {
    expect(await factory.createOrNull(), isNull);
    expect(await factory.isConfigured(), isFalse);
  });

  test('未配置：create 抛 AINotConfiguredException', () async {
    await expectLater(factory.create(), throwsA(isA<AINotConfiguredException>()));
  });

  test('已配置：返回 OpenAICompatibleProvider', () async {
    await services.aiSettings
        .set(AiSettingsRepository.baseUrlKey, 'https://open.bigmodel.cn/api/paas/v4');
    await services.aiSettings.set(AiSettingsRepository.modelKey, 'glm-4-flash');
    await keyStore.write(AIProviderFactory.apiKeySettingKey, 'user-key');

    final provider = await factory.createOrNull();
    expect(provider, isA<OpenAICompatibleProvider>());
    expect(await factory.isConfigured(), isTrue);
  });

  test('缺任意一项都视为未配置', () async {
    await services.aiSettings
        .set(AiSettingsRepository.baseUrlKey, 'https://x/v1');
    // 有 URL 没 model 没 key
    expect(await factory.createOrNull(), isNull);
    await services.aiSettings.set(AiSettingsRepository.modelKey, 'm');
    // 有 model 没 key
    expect(await factory.createOrNull(), isNull);
  });

  test('debugProvider 仅在显式传入时生效（测试 / Demo）', () async {
    final demoFactory = AIProviderFactory(
      settings: services.aiSettings,
      keyStore: keyStore,
      debugProvider: MockAIProvider(),
    );
    expect(await demoFactory.createOrNull(), isA<MockAIProvider>());
    // 生产工厂仍不受影响
    expect(await factory.createOrNull(), isNull);
  });

  test('testConnection：成功与鉴权失败', () async {
    final ok = OpenAICompatibleProvider(
      config: const AIConfig(
          baseUrl: 'https://example.invalid/v1', model: 'm', apiKey: 'k'),
      client: MockClient((request) async => http.Response(
          jsonEncode({
            'choices': [
              {
                'message': {'content': '{"ok": true}'}
              }
            ]
          }),
          200)),
    );
    await expectLater(ok.testConnection(), completes);

    final denied = OpenAICompatibleProvider(
      config: const AIConfig(
          baseUrl: 'https://example.invalid/v1', model: 'm', apiKey: 'k'),
      client: MockClient((request) async => http.Response('denied', 401)),
    );
    await expectLater(denied.testConnection(), throwsA(isA<AIAuthException>()));
  });
}
