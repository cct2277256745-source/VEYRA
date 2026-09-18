/// VEYRA Motion & Interaction Primitives（Motion Pass）。
/// 遵循 Quiet, Subtle, Fast, Functional 原则。
/// 严禁炫技、大范围位移与非必要动画。
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

/// 沉浸式桌面路由过渡：
/// Opacity (0.0 → 1.0) + 微小垂直位移（6–10px），提供「进入上下文」而非「翻开新网页」的质感。
class VeyraPageRoute<T> extends PageRouteBuilder<T> {
  VeyraPageRoute({
    required WidgetBuilder builder,
    super.settings,
    this.enableSlide = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: VeyraMotion.emphasized,
          reverseTransitionDuration: VeyraMotion.standard,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (VeyraMotion.isReducedMotion(context)) {
              return FadeTransition(opacity: animation, child: child);
            }

            // 主进入动画：柔和渐显 + 8px 垂直微升
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: VeyraMotion.curve,
              reverseCurve: VeyraMotion.curveIn,
            );

            final fade = FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );

            if (!enableSlide) return fade;

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.012), // ~8-10px 垂直微升
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: fade,
            );
          },
        );

  final bool enableSlide;
}

/// 统一的静音淡入淡出切换器：用于 Tab 切换、状态变迁、Empty / Loading 与 Content 之间。
class VeyraFadeSwitcher extends StatelessWidget {
  const VeyraFadeSwitcher({
    super.key,
    required this.child,
    this.duration = VeyraMotion.standard,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final Duration duration;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final effectiveDuration = VeyraMotion.duration(context, duration);

    return AnimatedSwitcher(
      duration: effectiveDuration,
      switchInCurve: VeyraMotion.curve,
      switchOutCurve: VeyraMotion.curveIn,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: alignment,
          children: [
            ...previousChildren,
            ?currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}

/// 展开/收起过渡容器：折叠区、二级信息、已归档项目。
class VeyraExpandable extends StatelessWidget {
  const VeyraExpandable({
    super.key,
    required this.isExpanded,
    required this.child,
    this.duration = VeyraMotion.standard,
  });

  final bool isExpanded;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final effectiveDuration = VeyraMotion.duration(context, duration);

    return AnimatedSize(
      duration: effectiveDuration,
      curve: VeyraMotion.curveInOut,
      alignment: Alignment.topCenter,
      child: isExpanded
          ? child
          : const SizedBox(width: double.infinity, height: 0),
    );
  }
}

/// 统一桌面模态弹窗过渡（0.98 → 1.0 缩放 + Opacity 渐现，180–200ms）。
Future<T?> showVeyraDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String? barrierLabel,
}) {
  final reducedMotion = VeyraMotion.isReducedMotion(context);

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel ?? 'Dismiss',
    barrierColor: const Color(0x330F172A),
    transitionDuration: reducedMotion ? Duration.zero : VeyraMotion.standard,
    pageBuilder: (ctx, anim1, anim2) => builder(ctx),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: VeyraMotion.curve,
        reverseCurve: VeyraMotion.curveIn,
      );

      final fade = FadeTransition(
        opacity: curved,
        child: child,
      );

      if (reducedMotion) return fade;

      return ScaleTransition(
        scale: Tween<double>(begin: 0.985, end: 1.0).animate(curved),
        child: fade,
      );
    },
  );
}

/// 桌面可点击卡片 / 容器微交互包装组件：
/// 统一管理 Hover（-1.5px lift / surface）、Press（0.99 scale / 压感）与键盘 Focus 态。
class VeyraPressable extends StatefulWidget {
  const VeyraPressable({
    super.key,
    required this.child,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
    this.liftOnHover = false,
    this.scaleOnPress = false,
    this.borderRadius,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback? onTap;
  final MouseCursor cursor;
  final bool liftOnHover;
  final bool scaleOnPress;
  final BorderRadius? borderRadius;
  final String? tooltip;

  @override
  State<VeyraPressable> createState() => _VeyraPressableState();
}

class _VeyraPressableState extends State<VeyraPressable> {
  bool _hovering = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final reduced = VeyraMotion.isReducedMotion(context);

    Widget content = widget.child;

    if (enabled && !reduced) {
      final yOffset = (_hovering && widget.liftOnHover) ? -1.5 : 0.0;
      final scale = (_pressed && widget.scaleOnPress) ? 0.99 : 1.0;

      content = AnimatedSlide(
        duration: VeyraMotion.fast,
        curve: VeyraMotion.curve,
        offset: Offset(0, yOffset / 50.0),
        child: AnimatedScale(
          duration: VeyraMotion.instant,
          curve: VeyraMotion.curve,
          scale: scale,
          child: content,
        ),
      );
    }

    // 键盘聚焦外圈（轻量鸢尾紫发光环，不污染设计语言）
    if (_focused && enabled) {
      content = Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(VeyraRadius.medium),
          boxShadow: [
            BoxShadow(
              color: VeyraColors.focusRing.withValues(alpha: 0.3),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: content,
      );
    }

    final detector = FocusableActionDetector(
      enabled: enabled,
      mouseCursor: enabled ? widget.cursor : SystemMouseCursors.basic,
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      onShowHoverHighlight: (v) => setState(() => _hovering = v),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onTap,
        child: content,
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: detector);
    }
    return detector;
  }
}
