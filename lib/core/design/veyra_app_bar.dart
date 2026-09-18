import 'package:flutter/material.dart';

import 'tokens.dart';

/// 沉浸式 macOS 风格二级导航条（UI Specification §4）
/// 避让 macOS 原生红绿灯（x: 13..68），并在 x: 76 处优雅承接返回按钮与标题。
class VeyraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VeyraAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
  });

  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        52.0 + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    Widget? effectiveLeading = leading;
    final canPop = Navigator.of(context).canPop();

    if (effectiveLeading == null && automaticallyImplyLeading && canPop) {
      effectiveLeading = const Padding(
        padding: EdgeInsets.only(left: 76),
        child: BackButton(),
      );
    }

    return AppBar(
      toolbarHeight: 52,
      leadingWidth: effectiveLeading != null ? 122 : 76,
      leading: effectiveLeading ?? const SizedBox(width: 76),
      title: title,
      titleTextStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: VeyraColors.textPrimary,
      ),
      actions: [
        ...?actions,
        const SizedBox(width: VeyraSpacing.s12),
      ],
      bottom: bottom,
    );
  }
}
