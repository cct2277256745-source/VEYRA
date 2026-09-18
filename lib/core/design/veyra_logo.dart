import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'tokens.dart';

/// VEYRA 品牌 Logo 方案枚举
enum VeyraLogoStyle {
  /// 旗舰主打：「顶峰动量 · The Zenith Vector」
  /// 灵感源自 Apple / Linear 顶级纯粹极简哲学。
  /// 左翼为沉稳奠基支柱（象征系统化拆解），右翼为 45° 动力斜切的破局跃升之刃（象征专注推进）。
  /// 纯粹自洽的几何雕塑，无任何多余塞入的圆点与杂质。
  zenithVector,

  /// 空间棱镜折线（Modern Tech / Bauhaus 风格）
  prismTrajectory,

  /// 原研哉超椭圆雕刻（Xiaomi / Kenya Hara n=3 风格）
  aliveSquircle,

  /// 历史备选：聚焦之核（Focus Orb）
  focusOrb,

  /// 历史备选：隐形之矢（Ascending Vector）
  ascendingVector,
}

/// VEYRA 品牌 Logo 渲染组件
class VeyraLogo extends StatelessWidget {
  const VeyraLogo({
    super.key,
    this.size = 24.0,
    this.style = VeyraLogoStyle.zenithVector,
    this.primaryColor,
    this.secondaryColor,
    this.coreColor,
  });

  final double size;
  final VeyraLogoStyle style;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? coreColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: switch (style) {
          VeyraLogoStyle.zenithVector => _ZenithVectorPainter(
              primaryColor: primaryColor ?? VeyraColors.textPrimary,
              secondaryColor: secondaryColor ?? VeyraColors.dopamineIris,
            ),
          VeyraLogoStyle.prismTrajectory => _PrismTrajectoryPainter(
              accentColor: primaryColor ?? VeyraColors.dopamineIris,
            ),
          VeyraLogoStyle.aliveSquircle => _AliveSquirclePainter(
              accentColor: primaryColor ?? VeyraColors.dopamineIris,
            ),
          VeyraLogoStyle.focusOrb => _FocusOrbPainter(
              primaryColor: primaryColor ?? VeyraColors.textPrimary,
              secondaryColor: secondaryColor ?? VeyraColors.dopamineIris,
              coreColor: coreColor,
            ),
          VeyraLogoStyle.ascendingVector => _AscendingVectorPainter(
              primaryColor: primaryColor ?? VeyraColors.textPrimary,
              secondaryColor: secondaryColor ?? VeyraColors.dopamineIris,
            ),
        },
      ),
    );
  }
}

/// 「聚焦之核 · The Focus Orb」CustomPainter
///
/// 精密几何：
/// - 两翼呈锐利建筑感 V 字汇聚：左翼（沉稳奠基），右翼（动力跃升）
/// - 中心汇聚处悬浮一颗核心圆（成果之核 · Focus Orb），象征项目终局目标与专注原点
/// - 环绕圆核有一圈纯净负空间间隙（Orbit Halo），呈现悬浮失重的精密奢感
class _FocusOrbPainter extends CustomPainter {
  const _FocusOrbPainter({
    required this.primaryColor,
    required this.secondaryColor,
    this.coreColor,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color? coreColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final s = math.min(w, h) / 2;

    final leftPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final rightPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final orbPaint = Paint()
      ..color = coreColor ?? secondaryColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 左翼多边形
    final leftPath = Path()
      ..moveTo(cx - s * 0.70, cy - s * 0.72)
      ..lineTo(cx - s * 0.32, cy - s * 0.72)
      ..lineTo(cx, cy + s * 0.32)
      ..lineTo(cx, cy + s * 0.76)
      ..lineTo(cx - s * 0.16, cy + s * 0.76)
      ..close();

    // 右翼多边形
    final rightPath = Path()
      ..moveTo(cx + s * 0.70, cy - s * 0.72)
      ..lineTo(cx + s * 0.32, cy - s * 0.72)
      ..lineTo(cx, cy + s * 0.32)
      ..lineTo(cx, cy + s * 0.76)
      ..lineTo(cx + s * 0.16, cy + s * 0.76)
      ..close();

    // 负空间光环（Orbit Halo Cutout）
    final orbY = cy - s * 0.10;
    final rHalo = s * 0.30;
    final rCore = s * 0.22;

    final haloPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, orbY), radius: rHalo));

    // 使用布尔运算剔除负空间环形，保证通透透视
    final carvedLeft = Path.combine(PathOperation.difference, leftPath, haloPath);
    final carvedRight = Path.combine(PathOperation.difference, rightPath, haloPath);

    canvas.drawPath(carvedLeft, leftPaint);
    canvas.drawPath(carvedRight, rightPaint);

    // 绘制悬浮的成果之核（Focus Orb）
    canvas.drawCircle(Offset(cx, orbY), rCore, orbPaint);
  }

  @override
  bool shouldRepaint(covariant _FocusOrbPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.coreColor != coreColor;
}

/// 「隐形之矢 · The Ascending Vector」CustomPainter
///
/// 精密几何坐标（基于中心对称与负空间黄金比例）：
/// 左右两翼环抱，中央由负空间自然构成一枚冲破天际的实心箭头与动力轴：
/// - 尖峰箭头在 (cx, cy - s * 0.18) 收尖
/// - 左右 Arrow Barb 在 (cx ± s * 0.30, cy + s * 0.16)
/// - 左右 Shaft Notch 在 (cx ± s * 0.12, cy + s * 0.16)
/// - 动力轴底部在 (cx ± s * 0.12, cy + s * 0.52)
/// - 底部统一收拢顶点于 (cx, cy + s * 0.82)
class _AscendingVectorPainter extends CustomPainter {
  const _AscendingVectorPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final s = math.min(w, h) / 2;

    final leftPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final rightPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 左翼多边形（沉稳奠基柱）
    final leftPath = Path()
      ..moveTo(cx - s * 0.78, cy - s * 0.78)
      ..lineTo(cx - s * 0.38, cy - s * 0.78)
      ..lineTo(cx, cy - s * 0.18) // 隐形箭头尖峰
      ..lineTo(cx - s * 0.30, cy + s * 0.16) // 箭头左倒钩
      ..lineTo(cx - s * 0.12, cy + s * 0.16) // 箭杆左收缩口
      ..lineTo(cx - s * 0.12, cy + s * 0.52) // 箭杆左底
      ..lineTo(cx, cy + s * 0.52) // 箭杆中心底
      ..lineTo(cx, cy + s * 0.82) // V 字底部尖点
      ..lineTo(cx - s * 0.18, cy + s * 0.82)
      ..close();

    // 右翼多边形（破局跃升翼）
    final rightPath = Path()
      ..moveTo(cx + s * 0.78, cy - s * 0.78)
      ..lineTo(cx + s * 0.38, cy - s * 0.78)
      ..lineTo(cx, cy - s * 0.18) // 隐形箭头尖峰
      ..lineTo(cx + s * 0.30, cy + s * 0.16) // 箭头右倒钩
      ..lineTo(cx + s * 0.12, cy + s * 0.16) // 箭杆右收缩口
      ..lineTo(cx + s * 0.12, cy + s * 0.52) // 箭杆右底
      ..lineTo(cx, cy + s * 0.52) // 箭杆中心底
      ..lineTo(cx, cy + s * 0.82) // V 字底部尖点
      ..lineTo(cx + s * 0.18, cy + s * 0.82)
      ..close();

    canvas.drawPath(leftPath, leftPaint);
    canvas.drawPath(rightPath, rightPaint);
  }

  @override
  bool shouldRepaint(covariant _AscendingVectorPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor;
}

/// 旗舰主打：Zenith Vector 极简独立矢量（Apple / Linear 哲学）
/// 纯粹的几何符号，摆脱底盒束缚。左侧沉稳奠基，右侧破局跃升，直指终局成果。
class _ZenithVectorPainter extends CustomPainter {
  const _ZenithVectorPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final s = math.min(w, h) / 2;

    final leftPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final rightPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 左侧支柱：沉稳有力的下行线，底角平实稳固
    final leftPath = Path()
      ..moveTo(cx - s * 0.82, cy - s * 0.62)
      ..lineTo(cx - s * 0.38, cy - s * 0.62)
      ..lineTo(cx - s * 0.05, cy + s * 0.65)
      ..lineTo(cx - s * 0.30, cy + s * 0.65)
      ..close();

    // 右侧矢量刃：向上延展并以 45° 动力斜角收尾，具有极强的前进动量
    final rightPath = Path()
      ..moveTo(cx - s * 0.15, cy + s * 0.65)
      ..lineTo(cx + s * 0.18, cy + s * 0.65)
      ..lineTo(cx + s * 0.90, cy - s * 0.40)
      ..lineTo(cx + s * 0.90, cy - s * 0.72)
      ..lineTo(cx + s * 0.52, cy - s * 0.72)
      ..close();

    canvas.drawPath(leftPath, leftPaint);
    canvas.drawPath(rightPath, rightPaint);
  }

  @override
  bool shouldRepaint(covariant _ZenithVectorPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor;
}

/// 方案 2：Alive Squircle 原研哉超椭圆 (n=3)
/// 致敬小米新 Logo，以拉梅曲线 (x/a)^3 + (y/b)^3 = 1 构建富有生命温润感的黑曜底座，内嵌极简圆润 V 与电光焦点
class _AliveSquirclePainter extends CustomPainter {
  const _AliveSquirclePainter({required this.accentColor});

  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final a = w / 2;
    final b = h / 2;

    // 原研哉 Lamé 曲线超椭圆 (n=3)
    final squirclePath = Path();
    const steps = 180;
    for (var i = 0; i <= steps; i++) {
      final theta = (i / steps) * 2 * math.pi;
      final cosT = math.cos(theta);
      final sinT = math.sin(theta);
      final rX = a * cosT.sign * math.pow(cosT.abs(), 2.0 / 3.0);
      final rY = b * sinT.sign * math.pow(sinT.abs(), 2.0 / 3.0);

      final pt = Offset(center.dx + rX, center.dy + rY);
      if (i == 0) {
        squirclePath.moveTo(pt.dx, pt.dy);
      } else {
        squirclePath.lineTo(pt.dx, pt.dy);
      }
    }
    squirclePath.close();

    // 陶瓷哑光黑曜底座
    final bgPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(squirclePath, bgPaint);

    // 内部极简高精密白色几何 V
    final vPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.135
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final vPath = Path()
      ..moveTo(w * 0.28, h * 0.33)
      ..lineTo(w * 0.50, h * 0.69)
      ..lineTo(w * 0.72, h * 0.33);

    canvas.drawPath(vPath, vPaint);

    // 右上角电光焦点：代表目标达成的点睛之笔
    final dotPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(Offset(w * 0.76, h * 0.27), w * 0.052, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _AliveSquirclePainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}

/// 方案 3：Prism Trajectory 连续空间折叠折线
/// 纯粹的现代科技折面：双色受光，极具空间与方向感
class _PrismTrajectoryPainter extends CustomPainter {
  const _PrismTrajectoryPainter({required this.accentColor});

  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final leftPaint = Paint()
      ..color = const Color(0xFF0EA5E9) // 晴空青受光面
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final rightPaint = Paint()
      ..color = accentColor // 鸢尾紫主色面
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 左翼棱面
    final leftWing = Path()
      ..moveTo(w * 0.15, h * 0.18)
      ..lineTo(w * 0.32, h * 0.18)
      ..lineTo(w * 0.50, h * 0.82)
      ..lineTo(w * 0.38, h * 0.82)
      ..close();

    // 右翼棱面
    final rightWing = Path()
      ..moveTo(w * 0.44, h * 0.82)
      ..lineTo(w * 0.56, h * 0.82)
      ..lineTo(w * 0.85, h * 0.18)
      ..lineTo(w * 0.68, h * 0.18)
      ..close();

    canvas.drawPath(leftWing, leftPaint);
    canvas.drawPath(rightWing, rightPaint);
  }

  @override
  bool shouldRepaint(covariant _PrismTrajectoryPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}
