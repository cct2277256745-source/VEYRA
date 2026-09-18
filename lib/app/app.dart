/// VeyraApp 外壳（UI Specification §4/§5/§6.1）：
/// Sidebar 224px（backgroundAlt + 1px border）+ 主内容区。
/// Sidebar 轻、克制：无 badge、无任务数字、无 AI 入口；设置在底部。
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/design/tokens.dart';
import '../core/design/veyra_logo.dart';
import '../core/design/veyra_motion.dart';

import '../features/inbox/inbox_page.dart';
import '../features/week/week_page.dart';
import '../features/projects/projects_page.dart';
import '../features/settings/settings_page.dart';

class VeyraApp extends StatelessWidget {
  const VeyraApp({super.key, this.fontFamily, this.home});

  /// 仅测试渲染环境使用：指定已通过 FontLoader 加载的字体族。
  final String? fontFamily;

  /// 仅视觉验收运行使用（--dart-define=VEYRA_DEMO_FOCUS=true）：
  /// 直接打开指定页面，跳过首页导航。
  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VEYRA',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(fontFamily: fontFamily),
      home: home ?? const _HomeShell(),
    );
  }
}

ThemeData _buildTheme({String? fontFamily}) {
  const scheme = ColorScheme.light(
    surface: VeyraColors.surface,
    primary: VeyraColors.primaryButton,
    onPrimary: Colors.white,
    secondary: VeyraColors.accentDustyBlue,
    error: VeyraColors.danger,
  );
  return ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    colorScheme: scheme,
    scaffoldBackgroundColor: VeyraColors.background,
    visualDensity: VisualDensity.comfortable,
    splashFactory: InkSparkle.splashFactory,
    dividerColor: VeyraColors.border,
    appBarTheme: const AppBarTheme(
      backgroundColor: VeyraColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: VeyraColors.textPrimary),
      titleTextStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: VeyraColors.textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: VeyraColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VeyraRadius.large),
        side: const BorderSide(color: VeyraColors.border),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(color: VeyraColors.border, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: VeyraColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VeyraRadius.medium),
        borderSide: const BorderSide(color: VeyraColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VeyraRadius.medium),
        borderSide: const BorderSide(color: VeyraColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VeyraRadius.medium),
        borderSide: const BorderSide(color: VeyraColors.textSecondary),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: VeyraColors.backgroundAlt,
      side: const BorderSide(color: VeyraColors.border),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VeyraRadius.small)),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VeyraRadius.medium))),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: VeyraColors.primaryButton,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VeyraRadius.medium)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: VeyraColors.accentDustyBlue,
        linearTrackColor: VeyraColors.border),
    dialogTheme: DialogThemeData(
      backgroundColor: VeyraColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      shadowColor: const Color(0x1A0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VeyraRadius.large),
        side: const BorderSide(color: VeyraColors.border),
      ),
    ),
  );
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _index = 1; // 默认落在「项目」

  void _openSettings() {
    Navigator.of(context).push(
      VeyraPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const WeekPage(),
      const ProjectsPage(),
      const InboxPage(),
    ];
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _VeyraSidebar(
            selectedIndex: _index,
            onSelect: (i) => setState(() => _index = i),
            onOpenSettings: _openSettings,
          ),
          Container(width: 1, color: VeyraColors.border),
          Expanded(
            child: VeyraFadeSwitcher(
              key: ValueKey(_index),
              duration: VeyraMotion.standard,
              child: pages[_index],
            ),
          ),
        ],
      ),
    );
  }
}

class _VeyraSidebar extends StatelessWidget {
  static const _destinations = [
    (Icons.calendar_view_week_rounded, '周计划'),
    (Icons.folder_outlined, '项目'),
    (Icons.inbox_rounded, '收件箱'),
  ];

  const _VeyraSidebar({
    required this.selectedIndex,
    required this.onSelect,
    required this.onOpenSettings,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 224,
      color: VeyraColors.backgroundAlt,
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // —— 品牌字标与微 Logo ——
            Padding(
              padding: const EdgeInsets.fromLTRB(
                VeyraSpacing.s20,
                52,
                VeyraSpacing.s20,
                VeyraSpacing.s20,
              ),
              child: Row(
                children: [
                  const VeyraLogo(
                    size: 20,
                    style: VeyraLogoStyle.zenithVector,
                  ),
                  const SizedBox(width: VeyraSpacing.s10),
                  const Text(
                    'VEYRA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.2,
                      color: VeyraColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: VeyraSpacing.s8),
            // —— 导航项 ——
            for (var i = 0; i < _destinations.length; i++)
              _SidebarItem(
                icon: _destinations[i].$1,
                label: _destinations[i].$2,
                selected: selectedIndex == i,
                onTap: () => onSelect(i),
              ),
            // —— 大面积留白 ——
            const Spacer(),
            // —— 设置：底部辅助位置 ——
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: VeyraSpacing.s16,
                vertical: VeyraSpacing.s12,
              ),
              height: 1,
              color: VeyraColors.border.withValues(alpha: 0.6),
            ),
            _SidebarItem(
              icon: Icons.settings_outlined,
              label: '设置',
              selected: false,
              onTap: onOpenSettings,
            ),
            const SizedBox(height: VeyraSpacing.s16),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovering = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final background = widget.selected
        ? VeyraColors.sidebarSelected
        : _pressed
            ? VeyraColors.pressedOverlay
            : _hovering
                ? VeyraColors.hoverOverlay
                : Colors.transparent;

    final textColor = widget.selected
        ? VeyraColors.dopamineIris
        : _hovering
            ? VeyraColors.textPrimary
            : VeyraColors.textSecondary;

    final iconColor = widget.selected
        ? VeyraColors.dopamineIris
        : _hovering
            ? VeyraColors.textPrimary
            : VeyraColors.textSecondary;

    final border = widget.selected
        ? Border.all(color: VeyraColors.dopamineIris.withValues(alpha: 0.2))
        : _focused
            ? Border.all(color: VeyraColors.focusRing.withValues(alpha: 0.35), width: 1.5)
            : null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: VeyraSpacing.s12,
        vertical: 2,
      ),
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        onShowHoverHighlight: (v) => setState(() => _hovering = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: VeyraMotion.fast,
            curve: VeyraMotion.curve,
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: VeyraSpacing.s12),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(VeyraRadius.medium),
              border: border,
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 16,
                  color: iconColor,
                ),
                const SizedBox(width: VeyraSpacing.s12),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight:
                        widget.selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
