/// AI Provider 工厂。
///
/// 生产规则（Phase 2.10）：未配置 Provider 时绝不静默使用 Mock 生成假规划。
/// - [createOrNull]：已配置返回真实 Provider；未配置返回 null（UI 显示引导）。
/// - [debugProvider]：仅限测试 / 明确的 Demo 环境，显式传入 Mock；
///   生产 main.dart 永不传入。
/// - [create]：配置齐全返回真实 Provider；未配置时抛 AINotConfiguredException。
library;

import '../data/repositories/ai_settings_repository.dart';
import 'ai_provider.dart';
import 'openai_compatible_provider.dart';
import 'secure_key_store.dart';

class AIProviderFactory {
  AIProviderFactory({
    required this.settings,
    required this.keyStore,
    this.debugProvider,
  });

  final AiSettingsRepository settings;
  final SecureKeyStore keyStore;

  /// 仅测试 / 明确 Demo 环境使用的固定 Provider（如 MockAIProvider）。
  final AIProvider? debugProvider;

  static const apiKeySettingKey = 'ai.apikey';

  Future<bool> isConfigured() async {
    if (debugProvider != null) return true;
    final baseUrl = await settings.get(AiSettingsRepository.baseUrlKey);
    final model = await settings.get(AiSettingsRepository.modelKey);
    final key = await keyStore.read(apiKeySettingKey);
    return _configured(baseUrl, model, key);
  }

  /// 返回真实 Provider；未配置返回 null，由 UI 显示引导提示。
  Future<AIProvider?> createOrNull() async {
    if (debugProvider != null) return debugProvider;
    final baseUrl = await settings.get(AiSettingsRepository.baseUrlKey);
    final model = await settings.get(AiSettingsRepository.modelKey);
    final key = await keyStore.read(apiKeySettingKey);
    if (!_configured(baseUrl, model, key)) return null;
    return _openAi(baseUrl!, model!, key!);
  }

  /// 需要保证可用时使用；未配置抛 AINotConfiguredException。
  Future<AIProvider> create() async {
    final provider = await createOrNull();
    if (provider == null) {
      throw AINotConfiguredException();
    }
    return provider;
  }

  bool _configured(String? baseUrl, String? model, String? key) =>
      baseUrl != null &&
      baseUrl.isNotEmpty &&
      model != null &&
      model.isNotEmpty &&
      key != null &&
      key.isNotEmpty;

  OpenAICompatibleProvider _openAi(String baseUrl, String model, String key) =>
      OpenAICompatibleProvider(
        config: AIConfig(baseUrl: baseUrl, model: model, apiKey: key),
      );
}
