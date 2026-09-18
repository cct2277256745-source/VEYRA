/// Settings 页（Phase 2.10）：AI Provider 配置，朴素功能性实现。
/// API Key 只写系统安全存储，永不入库、永不落明文（AGENTS §6）。
library;

import 'package:flutter/material.dart';

import '../../ai/ai_provider.dart';
import '../../ai/ai_provider_factory.dart';
import '../../ai/openai_compatible_provider.dart';
import '../../app/app_scope.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/ai_settings_repository.dart';

import '../../core/design/tokens.dart';
import '../../core/design/veyra_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with AppServicesAccess {
  final _baseUrl = TextEditingController();
  final _model = TextEditingController();
  final _apiKey = TextEditingController();
  bool _hasSavedKey = false;
  bool _saving = false;
  bool _testing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final factory = AIScope.of(context);
    final savedBaseUrl =
        await services.aiSettings.get(AiSettingsRepository.baseUrlKey) ?? '';
    final savedModel =
        await services.aiSettings.get(AiSettingsRepository.modelKey) ?? '';
    final savedKey =
        await factory.keyStore.read(AIProviderFactory.apiKeySettingKey);
    if (mounted) {
      setState(() {
        _baseUrl.text = savedBaseUrl;
        _model.text = savedModel;
        _hasSavedKey = savedKey != null && savedKey.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _baseUrl.dispose();
    _model.dispose();
    _apiKey.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final factory = AIScope.of(context);
    if (_baseUrl.text.trim().isNotEmpty) {
      await services.aiSettings
          .set(AiSettingsRepository.baseUrlKey, _baseUrl.text.trim());
    }
    if (_model.text.trim().isNotEmpty) {
      await services.aiSettings
          .set(AiSettingsRepository.modelKey, _model.text.trim());
    }
    if (_apiKey.text.trim().isNotEmpty) {
      await factory.keyStore
          .write(AIProviderFactory.apiKeySettingKey, _apiKey.text.trim());
    }
    final savedKey =
        await factory.keyStore.read(AIProviderFactory.apiKeySettingKey);
    if (mounted) {
      setState(() {
        _hasSavedKey = savedKey != null && savedKey.isNotEmpty;
        _apiKey.clear();
        _saving = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('已保存。Key 存在系统安全存储里。')));
    }
  }

  Future<void> _testConnection() async {
    setState(() => _testing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final factory = AIScope.of(context);
      var baseUrl = _baseUrl.text.trim();
      if (baseUrl.isEmpty) {
        baseUrl =
            await services.aiSettings.get(AiSettingsRepository.baseUrlKey) ?? '';
      }
      var model = _model.text.trim();
      if (model.isEmpty) {
        model =
            await services.aiSettings.get(AiSettingsRepository.modelKey) ?? '';
      }
      var apiKey = _apiKey.text.trim();
      if (apiKey.isEmpty) {
        apiKey =
            await factory.keyStore.read(AIProviderFactory.apiKeySettingKey) ?? '';
      }

      final missing = <String>[];
      if (baseUrl.isEmpty) missing.add('Base URL');
      if (model.isEmpty) missing.add('Model');
      if (apiKey.isEmpty) missing.add('API Key');

      if (missing.isNotEmpty) {
        messenger.showSnackBar(SnackBar(
            content: Text('还没有配置完整：需要 ${missing.join('、')}。')));
        return;
      }

      final provider = OpenAICompatibleProvider(
        config: AIConfig(baseUrl: baseUrl, model: model, apiKey: apiKey),
      );
      await provider.testConnection();
      messenger.showSnackBar(const SnackBar(content: Text('连接成功，AI 可以用了。')));
    } on AIException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('连接失败: $e')));
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VeyraAppBar(title: Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('AI 服务', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _baseUrl,
            decoration: const InputDecoration(
              labelText: 'Base URL',
              hintText: 'https://open.bigmodel.cn/api/paas/v4',
              helperText: '例如智谱 GLM: https://open.bigmodel.cn/api/paas/v4',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _model,
            decoration: const InputDecoration(
              labelText: 'Model',
              hintText: '例如 glm-4-flash',
              helperText: '智谱开放平台免费模型请填写 glm-4-flash',
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('glm-4-flash (智谱免费)',
                    style: TextStyle(fontSize: 11)),
                onPressed: () => setState(() => _model.text = 'glm-4-flash'),
              ),
              ActionChip(
                label: const Text('glm-4', style: TextStyle(fontSize: 11)),
                onPressed: () => setState(() => _model.text = 'glm-4'),
              ),
              ActionChip(
                label: const Text('gpt-4o-mini',
                    style: TextStyle(fontSize: 11)),
                onPressed: () => setState(() => _model.text = 'gpt-4o-mini'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _apiKey,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'API Key',
              helperText: _hasSavedKey
                  ? '✓ 已保存在系统安全存储（留空则不修改）'
                  : '只保存在系统安全存储里，不入数据库',
              helperStyle: TextStyle(
                color: _hasSavedKey
                    ? VeyraColors.success
                    : VeyraColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('保存'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: _testing ? null : _testConnection,
                child: _testing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('测试连接'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text('数据位置', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('数据库与全部本地数据：',
              style: Theme.of(context).textTheme.bodySmall),
          SelectableText(AppDatabase.defaultDatabaseFile().parent.path,
              style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          const Text('所有数据保存在本机，VEYRA 不上传任何内容。',
              style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
