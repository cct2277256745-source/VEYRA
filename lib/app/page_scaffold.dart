/// 页头（UI Specification §4 顶部动作区 + §6 页面标题区）：
/// 每页一个明显视觉标题（display 28）+ 可选一句轻量说明 + 顶部动作区。
library;

import 'package:flutter/material.dart';

import '../core/design/tokens.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.title,
    this.subtitle,
    this.breadcrumb,
    this.actions = const [],
    required this.body,
  });

  final String title;
  final String? subtitle;
  final Widget? breadcrumb;
  final List<Widget> actions;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VeyraSpacing.s32,
              52,
              VeyraSpacing.s32,
              0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (breadcrumb != null) ...[
                        breadcrumb!,
                        const SizedBox(height: VeyraSpacing.s4),
                      ],
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          height: 34 / 28,
                          fontWeight: FontWeight.w700,
                          color: VeyraColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: VeyraSpacing.s4),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 20 / 14,
                            color: VeyraColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (actions.isNotEmpty) ...[
                  const SizedBox(width: VeyraSpacing.s16),
                  ...actions,
                ],
              ],
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
