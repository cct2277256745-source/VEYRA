/// 全局注入：UI 层通过 AppScope.of(context) 访问 AppServices。
library;

import 'package:flutter/widgets.dart';

import '../../ai/ai_provider_factory.dart';
import '../data/app_services.dart';

class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.services, required super.child});

  final AppServices services;

  static AppServices of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!.services;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}

/// AI 工厂注入：预览页通过 AIScope.of(context) 创建 Provider。
class AIScope extends InheritedWidget {
  const AIScope({super.key, required this.factory, required super.child});

  final AIProviderFactory factory;

  static AIProviderFactory of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AIScope>();
    assert(scope != null, 'AIScope not found in widget tree');
    return scope!.factory;
  }

  @override
  bool updateShouldNotify(AIScope oldWidget) => false;
}

/// State 混入：在 didChangeDependencies 时机安全获取 AppServices。
mixin AppServicesAccess<T extends StatefulWidget> on State<T> {
  late AppServices services;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    services = AppScope.of(context);
  }
}
