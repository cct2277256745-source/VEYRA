/// AI 未配置状态统一文案与动作（UI Specification §9/§6.12）。
/// 不出现 API_KEY_MISSING / HTTP 401 / Provider null 等技术词。
library;

import 'package:flutter/material.dart';

import '../features/settings/settings_page.dart';

const aiNotConfiguredTitle = '规划功能需要 AI 服务。';
const aiNotConfiguredBody = '你的项目、周计划和本地数据仍然可以正常使用。';

/// SnackBar：友好提示 + 「配置 AI」动作直达设置页。
void showAiNotConfigured(BuildContext context) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(
    duration: const Duration(seconds: 5),
    content: const Text('$aiNotConfiguredTitle$aiNotConfiguredBody'),
    action: SnackBarAction(
      label: '配置 AI',
      onPressed: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
      },
    ),
  ));
}
