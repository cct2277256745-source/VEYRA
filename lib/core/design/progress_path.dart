/// Progress Path（UI Specification §6.3）：VEYRA 品牌视觉重点。
/// 用节点轨迹代替百分比条——用户看的是「我走到哪里了」。
/// Revision 1：弱化 Stepper 感——completed 65%、current 100% + 极轻 halo、
/// future 低对比；非当前 label 降权，突出 Current Phase。
library;

import 'package:flutter/material.dart';

import 'tokens.dart';

class ProgressPathNode {
  const ProgressPathNode({
    required this.completed,
    this.current = false,
    this.label,
  });

  final bool completed;
  final bool current;
  final String? label;
}

class ProgressPath extends StatelessWidget {
  const ProgressPath({
    super.key,
    required this.nodes,
    this.accent = VeyraColors.defaultAccent,
    this.showLabels = true,
    this.nodeSize = 13,
  });

  final List<ProgressPathNode> nodes;
  final Color accent;

  /// 迷你版（项目卡内）只画节点线，不带文字。
  final bool showLabels;
  final double nodeSize;

  Color get _completedColor => VeyraColors.success;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const SizedBox.shrink();
    final effectiveNodeSize = showLabels ? 24.0 : nodeSize;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            showLabels ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < nodes.length; i++) ...[
            if (i > 0) _segment(nodes[i - 1], effectiveNodeSize),
            _node(context, nodes[i], effectiveNodeSize),
          ],
        ],
      ),
    );
  }

  Widget _segment(ProgressPathNode previous, double effectiveNodeSize) {
    final reached = previous.completed;
    return Container(
      width: showLabels ? 52 : 24,
      height: 2,
      margin: EdgeInsets.only(
        top: showLabels ? (effectiveNodeSize / 2 - 1) : 0,
      ),
      decoration: BoxDecoration(
        color: reached ? _completedColor : VeyraColors.border,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _node(
      BuildContext context, ProgressPathNode node, double effectiveNodeSize) {
    final Widget circle;
    if (showLabels) {
      if (node.completed) {
        circle = Container(
          width: effectiveNodeSize,
          height: effectiveNodeSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _completedColor,
          ),
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        );
      } else if (node.current) {
        circle = Container(
          width: effectiveNodeSize,
          height: effectiveNodeSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accent,
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.35),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        circle = Container(
          width: effectiveNodeSize,
          height: effectiveNodeSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: VeyraColors.surface,
            border: Border.all(color: VeyraColors.border, width: 1.5),
          ),
        );
      }
    } else {
      circle = AnimatedContainer(
        duration: VeyraMotion.progress,
        curve: VeyraMotion.curve,
        width: effectiveNodeSize,
        height: effectiveNodeSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: node.current
              ? accent
              : node.completed
                  ? _completedColor
                  : VeyraColors.background,
          border: node.current
              ? null
              : Border.all(
                  color:
                      node.completed ? Colors.transparent : VeyraColors.border,
                  width: 1.5,
                ),
        ),
      );
    }

    if (!showLabels || node.label == null) return circle;

    return SizedBox(
      width: 88,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circle,
          const SizedBox(height: VeyraSpacing.s8),
          Text(
            node.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: node.current ? 13 : 12,
              height: 1.3,
              color: node.current
                  ? VeyraColors.textPrimary
                  : node.completed
                      ? VeyraColors.textSecondary
                      : VeyraColors.textTertiary,
              fontWeight: node.current ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (node.current)
            const Text(
              '(进行中)',
              style: TextStyle(
                fontSize: 10,
                color: VeyraColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
