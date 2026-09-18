/// Linear 风格微胶囊标签体系（VEYRA 核心设计）。
/// 低饱和、高辨识度、精密小圆角。
library;

import 'package:flutter/material.dart';

import '../domain/enums.dart';
import 'tokens.dart';

class VeyraPriorityBadge extends StatelessWidget {
  const VeyraPriorityBadge({super.key, required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final isMust = priority == TaskPriority.must;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isMust ? VeyraColors.mustBg : VeyraColors.optionalBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isMust ? '必做' : '可选',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isMust ? VeyraColors.mustText : VeyraColors.optionalText,
          height: 1.2,
        ),
      ),
    );
  }
}

class VeyraEffortBadge extends StatelessWidget {
  const VeyraEffortBadge({super.key, required this.effort});

  final EstimatedEffort effort;

  @override
  Widget build(BuildContext context) {
    final (label, hours) = switch (effort) {
      EstimatedEffort.small => ('小', '30m'),
      EstimatedEffort.medium => ('中', '1.5h'),
      EstimatedEffort.large => ('大', '3h+'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: VeyraColors.tagBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hours,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: VeyraColors.tagText,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class VeyraTagBadge extends StatelessWidget {
  const VeyraTagBadge({
    super.key,
    required this.label,
    Color? backgroundColor,
    Color? background,
    Color? textColor,
    Color? color,
    this.icon,
  })  : backgroundColor = background ?? backgroundColor,
        textColor = color ?? textColor;

  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final fg = textColor ?? VeyraColors.tagText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? VeyraColors.tagBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: fg,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class VeyraCountBadge extends StatelessWidget {
  const VeyraCountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: VeyraColors.border,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: VeyraColors.textSecondary,
        ),
      ),
    );
  }
}
