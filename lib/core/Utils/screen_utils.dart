import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized responsive sizing using flutter_screenutil
class ScreenUtils {
  ScreenUtils._();

  /// DESIGN SIZE (based on Figma)
  static const designWidth = 440.0;
  static const designHeight = 956.0;

  /// -----------------------------
  /// SPACING (Horizontal spacing)
  /// -----------------------------
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 16.w;
  static double get lg => 20.w;
  static double get xl => 24.w;
  static double get xxl => 32.w;

  /// -----------------------------
  /// VERTICAL SPACING
  /// -----------------------------
  static double get vXs => 4.h;
  static double get vSm => 8.h;
  static double get vMd => 16.h;
  static double get vLg => 20.h;
  static double get vXl => 32.h;
  static double get vXxl => 40.h;

  /// -----------------------------
  /// FONT SIZES
  /// -----------------------------
  static double get fontXs => 10.sp;
  static double get fontSm => 12.sp;
  static double get fontMd => 14.sp;
  static double get fontLg => 16.sp;
  static double get fontXl => 20.sp;
  static double get fontTitle => 24.sp;
  static double get fontHeadline => 32.sp;

  /// -----------------------------
  /// BORDER RADIUS
  /// -----------------------------
  static double get radiusXs => 4.r;
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 24.r;

  /// -----------------------------
  /// ICON SIZES
  /// -----------------------------
  static double get iconSm => 16.w;
  static double get iconMd => 24.w;
  static double get iconLg => 32.w;

  /// -----------------------------
  /// COMPONENT HEIGHTS
  /// -----------------------------
  static double get buttonHeight => 52.h;
  static double get inputHeight => 52.h;
  static double get appBarHeight => 56.h;
}
