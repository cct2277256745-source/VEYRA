/// Things 3 风格圆环复选框（VEYRA 核心设计交互）。
/// 细腻的 1.5px 描边、轻柔 Hover 态、平滑的勾选微动画。
library;

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'tokens.dart';

class VeyraCheckbox extends StatefulWidget {
  const VeyraCheckbox({
    super.key,
    this.value = false,
    bool? checked,
    this.onChanged,
    this.onToggle,
    Color? activeColor,
    Color? accentColor,
    this.size = 20,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
  })  : isChecked = checked ?? value,
        effectiveColor = accentColor ?? activeColor;

  final bool value;
  final bool isChecked;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onToggle;
  final double size;
  final Color? effectiveColor;
  final String? tooltip;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  State<VeyraCheckbox> createState() => _VeyraCheckboxState();
}

class _VeyraCheckboxState extends State<VeyraCheckbox> {
  bool _hovering = false;
  bool _pressed = false;
  bool _focused = false;

  void _triggerToggle() {
    if (widget.onChanged != null) {
      widget.onChanged!(!widget.isChecked);
    } else if (widget.onToggle != null) {
      widget.onToggle!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.effectiveColor ?? VeyraColors.success;
    final enabled = widget.onChanged != null || widget.onToggle != null;
    final checked = widget.isChecked;
    final reduced = VeyraMotion.isReducedMotion(context);

    Widget circle = AnimatedContainer(
      duration: VeyraMotion.fast,
      curve: VeyraMotion.curve,
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: checked
            ? active
            : _hovering
                ? active.withValues(alpha: 0.12)
                : Colors.transparent,
        border: Border.all(
            color: checked
                ? active
                : _hovering
                    ? active
                    : VeyraColors.checkboxBorder,
            width: 1.5,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: active.withValues(alpha: 0.35),
                    blurRadius: 4,
                    spreadRadius: 1.5,
                  ),
                ]
              : null,
      ),
      child: Center(
        child: AnimatedScale(
          scale: checked ? 1.0 : 0.0,
          duration: reduced ? Duration.zero : VeyraMotion.instant,
          curve: VeyraMotion.curveFast,
          child: Icon(
            Icons.check,
            size: widget.size * 0.65,
            color: Colors.white,
          ),
        ),
      ),
    );

    if (enabled && !reduced) {
      circle = AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: VeyraMotion.instant,
        curve: VeyraMotion.curveFast,
        child: circle,
      );
    }

    final detector = FocusableActionDetector(
      enabled: enabled,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      mouseCursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      onShowHoverHighlight: (v) => setState(() => _hovering = v),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _triggerToggle();
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
        onTap: enabled ? _triggerToggle : null,
        child: circle,
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: detector);
    }
    return detector;
  }
}
