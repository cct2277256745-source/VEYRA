import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design/tokens.dart';

/// 禅意呼吸心流环（Zen Breathing Flow Ring）：
/// 采用 Canvas 绘制的极简环形光晕计时器，配备 4 秒舒缓窦性呼吸光晕（Inhale/Exhale 相干性心流）。
class ZenBreathingRing extends StatefulWidget {
  const ZenBreathingRing({
    super.key,
    required this.progress,
    required this.timeDisplay,
    required this.stateLabel,
    required this.isRunning,
    this.ringColor = VeyraColors.dopamineIris,
    this.diameter = 260.0,
  });

  final double progress;
  final String timeDisplay;
  final String stateLabel;
  final bool isRunning;
  final Color ringColor;
  final double diameter;

  @override
  State<ZenBreathingRing> createState() => _ZenBreathingRingState();
}

class _ZenBreathingRingState extends State<ZenBreathingRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    // 4000ms 舒缓生理呼吸周期（2s 吸气微扩 / 2s 呼气微敛）
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, _) {
        final breathingPhase = _breathingController.value;
        return SizedBox(
          width: widget.diameter,
          height: widget.diameter,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.diameter, widget.diameter),
                painter: _BreathingRingPainter(
                  progress: widget.progress.clamp(0.0, 1.0),
                  breathingPhase: breathingPhase,
                  isRunning: widget.isRunning,
                  accentColor: widget.ringColor,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.timeDisplay,
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.0,
                      color: VeyraColors.textPrimary,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: VeyraSpacing.s10,
                      vertical: VeyraSpacing.s4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isRunning
                          ? VeyraColors.selectedSurface(VeyraColors.dopamineMint)
                          : VeyraColors.selectedSurface(VeyraColors.dopamineCoral),
                      borderRadius: BorderRadius.circular(VeyraRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.isRunning
                                ? VeyraColors.dopamineMint
                                : VeyraColors.dopamineCoral,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.stateLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: widget.isRunning
                                ? const Color(0xFF047857)
                                : const Color(0xFFC2410C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BreathingRingPainter extends CustomPainter {
  _BreathingRingPainter({
    required this.progress,
    required this.breathingPhase,
    required this.isRunning,
    required this.accentColor,
  });

  final double progress;
  final double breathingPhase;
  final bool isRunning;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;

    // 1. 舒缓微光呼吸底晕（Sinusoidal Breathing Aura）
    if (isRunning) {
      final breathFactor = (math.sin(breathingPhase * 2 * math.pi) + 1.0) / 2.0; // 0.0 ~ 1.0
      final auraRadius = radius + 6 + (breathFactor * 8.0);
      final auraPaint = Paint()
        ..color = accentColor.withValues(alpha: 0.04 + (breathFactor * 0.06))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
      canvas.drawCircle(center, auraRadius, auraPaint);
    }

    // 2. 底层静音灰度轨道
    final trackPaint = Paint()
      ..color = VeyraColors.border.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawCircle(center, radius, trackPaint);

    // 3. 进度流光渐变弧线
    if (progress > 0.001) {
      final sweepAngle = 2 * math.pi * progress;
      final startAngle = -math.pi / 2; // 从 12 点钟方向起步

      final gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: [
          accentColor,
          VeyraColors.dopamineMint,
        ],
        tileMode: TileMode.clamp,
      );

      final rect = Rect.fromCircle(center: center, radius: radius);
      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.5;

      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

      // 4. 前端高亮发光微球
      final endAngle = startAngle + sweepAngle;
      final dotX = center.dx + radius * math.cos(endAngle);
      final dotY = center.dy + radius * math.sin(endAngle);
      final dotCenter = Offset(dotX, dotY);

      final dotAuraPaint = Paint()
        ..color = VeyraColors.dopamineMint.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(dotCenter, 5.0, dotAuraPaint);

      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotCenter, 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BreathingRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.breathingPhase != breathingPhase ||
        oldDelegate.isRunning != isRunning ||
        oldDelegate.accentColor != accentColor;
  }
}
