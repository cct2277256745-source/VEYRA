/// VEYRA Design Tokens。
/// 全 App 禁止硬编码颜色 / 间距 / 圆角 / 时长。
library;

import 'package:flutter/material.dart';

class VeyraColors {
  VeyraColors._();

  // 基础（Crisp Minimalist & Dopamine 纯净现代画布）
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundAlt = Color(0xFFF1F5F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);

  // 多巴胺活力色彩体系（Dopamine Palette：轻快、高能量、纯净高级）
  static const Color dopamineIris = Color(0xFF6366F1);     // 电光鸢尾紫
  static const Color dopamineMint = Color(0xFF10B981);     // 霓虹薄荷绿
  static const Color dopamineCoral = Color(0xFFF97316);    // 晚霞活力橙
  static const Color dopamineBerry = Color(0xFFEC4899);    // 鲜嫩浆果粉
  static const Color dopamineCyan = Color(0xFF0EA5E9);     // 晴空电光青
  static const Color dopamineViolet = Color(0xFF8B5CF6);   // 晶透极光紫

  // 项目 Accent（默认采用轻快活泼的电光紫）
  static const Color accentSage = dopamineMint;
  static const Color accentDustyBlue = dopamineIris;
  static const Color accentSoftCoral = dopamineCoral;
  static const Color accentMutedViolet = dopamineViolet;
  static const Color accentPaleOchre = Color(0xFFEAB308);

  /// 默认项目 Accent
  static const Color defaultAccent = dopamineIris;

  // 语义
  static const Color success = dopamineMint;
  static const Color successBg = Color(0xFFECFDF5);
  static const Color warning = dopamineCoral;
  static const Color warningBg = Color(0xFFFFF7ED);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerBg = Color(0xFFFEF2F2);
  static const Color focusRing = dopamineIris;

  // 标签与微胶囊配色（活泼轻快多巴胺）
  static const Color mustBg = Color(0xFFFEE2E2);
  static const Color mustText = Color(0xFFDC2626);
  static const Color mustBadgeBg = mustBg;
  static const Color mustBadgeText = mustText;
  static const Color optionalBg = Color(0xFFF1F5F9);
  static const Color optionalText = Color(0xFF475569);
  static const Color tagBg = Color(0xFFF1F5F9);
  static const Color tagText = Color(0xFF334155);

  // 多巴胺焦点卡片（告别土黄色，改用高能清爽电光鸢尾卡）
  static const Color dopamineCardBg = Color(0xFFF5F6FF);
  static const Color dopamineCardBorder = Color(0xFFDDE1FE);
  static const Color dopamineCardTitle = Color(0xFF3730A3);

  // 兼容别名
  static const Color amberCardBg = dopamineCardBg;
  static const Color amberCardBorder = dopamineCardBorder;
  static const Color amberCardTitle = dopamineCardTitle;
  static const Color checkboxBorder = Color(0xFFCBD5E1);

  // 阴影
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x060F172A),
      blurRadius: 6,
      offset: Offset(0, 1),
    ),
  ];
  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 14,
      offset: Offset(0, 4),
    ),
  ];

  // Primary 按钮（深邃深炭）
  static const Color primaryButton = Color(0xFF0F172A);

  // 交互叠加
  static const Color hoverOverlay = Color(0x080F172A);
  static const Color pressedOverlay = Color(0x100F172A);

  // Sidebar 选中态（轻柔鸢尾蓝）
  static const Color sidebarSelected = Color(0xFFEEF2FF);

  /// 项目 Accent @ 10% 透明度（选中底色）。
  static Color selectedSurface(Color accent) =>
      accent.withValues(alpha: 0.08);

  static Color fromArgb(int? argb, {Color fallback = defaultAccent}) =>
      argb == null ? fallback : Color(argb);
}

class VeyraShadows {
  VeyraShadows._();

  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x0E000000),
      blurRadius: 12,
      offset: Offset(0, 3),
    ),
  ];
}

class VeyraSpacing {
  VeyraSpacing._();

  static const double s2 = 2;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s64 = 64;
}

class VeyraRadius {
  VeyraRadius._();

  static const double small = 8;
  static const double medium = 12;
  static const double large = 18;
  static const double xl = 24;
  static const double full = 999;
}

class VeyraMotion {
  VeyraMotion._();

  // 时长阶梯（UI Specification & Motion Pass）
  /// 瞬时反馈（80–100ms）：点击微按压、图标切换、复选框勾选
  static const Duration instant = Duration(milliseconds: 100);

  /// 快速微交互（120–160ms）：Hover 高亮、背景色渐变、次级操作显隐
  static const Duration fast = Duration(milliseconds: 140);

  /// 标准动画（180–220ms）：列表增删、展开折叠、弹窗进入
  static const Duration standard = Duration(milliseconds: 200);

  /// 强调过渡（240–300ms）：页面进入/Focus View 空间过渡、重要状态切换
  static const Duration emphasized = Duration(milliseconds: 260);

  /// 进度插值（300–360ms）：进度条流转、里程碑达成
  static const Duration progress = Duration(milliseconds: 340);

  // 统一缓动曲线
  /// 默认进入缓动：柔和减速，避免生硬撞墙
  static const Curve curve = Curves.easeOutCubic;

  /// 退出缓动：轻微加速退场
  static const Curve curveIn = Curves.easeInCubic;

  /// 对称缓动：状态转换、位置平移、跨页面淡入淡出
  static const Curve curveInOut = Curves.easeInOutCubic;

  /// 高响应缓动：桌面端即时反馈
  static const Curve curveFast = Curves.fastOutSlowIn;

  /// 检测系统是否开启「减少动态效果」（Reduced Motion）
  static bool isReducedMotion(BuildContext context) {
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  /// 响应无障碍 Reduced Motion 设置的时长适配
  static Duration duration(BuildContext context, Duration base) {
    return isReducedMotion(context) ? Duration.zero : base;
  }
}
