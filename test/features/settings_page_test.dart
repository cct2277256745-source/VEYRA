import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veyra/ai/ai_provider_factory.dart';
import 'package:veyra/ai/secure_key_store.dart';
import 'package:veyra/app/app.dart';
import 'package:veyra/app/app_scope.dart';
import 'package:veyra/data/app_services.dart';
import 'package:veyra/data/repositories/ai_settings_repository.dart';
import 'package:veyra/features/settings/settings_page.dart';

/// Phase 2.10：Settings 页 —— AI Provider 配置 + 数据位置。
void main() {
  late AppServices services;
  late InMemoryKeyStore keyStore;

  setUp(() {
    services = AppServices.inMemory();
    keyStore = InMemoryKeyStore();
  });

  tearDown(() => services.close());

  Future<void> pumpSettings(WidgetTester tester) async {
    final factory = AIProviderFactory(
      settings: services.aiSettings,
      keyStore: keyStore,
    );
    await tester.pumpWidget(AIScope(
      factory: factory,
      child: AppScope(
          services: services,
          child: const MaterialApp(home: SettingsPage())),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('保存：Base URL / Model 进 Settings，Key 进安全存储（不进数据库）',
      (tester) async {
    await pumpSettings(tester);

    await tester.enterText(
        find.widgetWithText(TextField, 'Base URL'), 'https://open.bigmodel.cn/api/paas/v4');
    await tester.enterText(
        find.widgetWithText(TextField, 'Model'), 'glm-4-flash');
    await tester.enterText(
        find.widgetWithText(TextField, 'API Key'), 'secret-key-123');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(
        await services.aiSettings.get(AiSettingsRepository.baseUrlKey),
        'https://open.bigmodel.cn/api/paas/v4');
    expect(await services.aiSettings.get(AiSettingsRepository.modelKey),
        'glm-4-flash');
    // Key 在安全存储，不在 Settings 表
    expect(await keyStore.read(AIProviderFactory.apiKeySettingKey),
        'secret-key-123');
    final dbValue =
        await services.aiSettings.get(AIProviderFactory.apiKeySettingKey);
    expect(dbValue, isNull, reason: 'API Key 绝不明文入库');
    // 保存后输入框清空且显示已保存
    expect(find.text('已保存。Key 存在系统安全存储里。'), findsOneWidget);
  });

  testWidgets('已有 Key 时显示提示且留空不覆盖', (tester) async {
    await keyStore.write(AIProviderFactory.apiKeySettingKey, 'existing-key');
    await pumpSettings(tester);

    expect(find.textContaining('已保存在系统安全存储'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextField, 'Base URL'), 'https://x/v1');
    await tester.enterText(find.widgetWithText(TextField, 'Model'), 'm');
    // Key 留空
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(await keyStore.read(AIProviderFactory.apiKeySettingKey),
        'existing-key', reason: '留空不修改');
  });

  testWidgets('未配置完整时测试连接给出引导提示', (tester) async {
    await pumpSettings(tester);
    await tester.tap(find.text('测试连接'));
    await tester.pumpAndSettle();
    expect(find.textContaining('还没有配置完整'), findsOneWidget);
  });

  testWidgets('显示本地数据位置', (tester) async {
    await pumpSettings(tester);
    expect(find.text('数据位置'), findsOneWidget);
    expect(find.textContaining('所有数据保存在本机'), findsOneWidget);
  });

  testWidgets('外壳齿轮图标可打开设置页', (tester) async {
    final factory = AIProviderFactory(
      settings: services.aiSettings,
      keyStore: keyStore,
    );
    await tester.pumpWidget(AIScope(
      factory: factory,
      child: AppScope(services: services, child: const VeyraApp()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('设置'), findsWidgets);
  });
}
