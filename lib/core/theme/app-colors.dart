import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  //---------------------------------------------------------------------------
  // BACKGROUND COLORS
  //---------------------------------------------------------------------------

  /// Main background color - White
  static const Color background = Colors.white;

  /// Notification card background - Blue with 7% opacity
  static Color notificationCardBg = primaryWithOpacity(0.07);

  //---------------------------------------------------------------------------
  // TEXT COLORS
  //---------------------------------------------------------------------------

  /// Heading text color - Black
  static const Color headingText = Color(0xFF000000);

  static const Color bodyText = Color(0xFF252B37);

  static const Color bodyText_light = Color(0xFF717680);

  static const Color blueText = Color(0xFF307DEF);

  static const Color purpleText = Color(0xFF6938EF);

  static const Color disableText = Color(0xFFFAFAFA);

  static const Color labelText = Color(0xFF0A0A0A);

  static const Color borderGrey = Color(0xFFC7C7CC);

  /// Primary text color (alias for headingText for backward compatibility)
  static const Color primaryText = headingText;

  /// Secondary text color (alias for bodyText for backward compatibility)
  static const Color secondaryText = labelText;

  static const Color hintText = Color(0xFFA4A7AE);

  //---------------------------------------------------------------------------
  // BUTTON & BRAND COLORS
  //---------------------------------------------------------------------------

  /// Primary brand color - Blue
  static const Color primary = Color(0xFF6938EF);

  //---------------------------------------------------------------------------
  // STATUS COLORS
  //---------------------------------------------------------------------------

  /// Success/Green text - Bright Green
  static const Color success = Color(0xFF009F00);

  /// Error/Red text - Bright Red
  static const Color error = Color(0xFFD90000);

  /// Warning text/icon - Amber/Orange
  static const Color warning = Color(0xFFF59E0B);

  //---------------------------------------------------------------------------
  // SEMANTIC COLORS
  //---------------------------------------------------------------------------

  /// Border color - Blue (matching button border)
  static const Color border = Color(0xFF0088FF);

  /// Success surface - Light Green
  static const Color successSurface = Color(0xFF009F00);

  /// Disabled/Inactive surface
  static const Color disabledSurface = Color(0xFFE9EAEB);

  /// Secondary surface (for alternate backgrounds)
  static const Color secondarySurface = Color(0xFFF2F2F7);

  //---------------------------------------------------------------------------
  // CONVENIENCE GETTERS WITH OPACITY
  //---------------------------------------------------------------------------

  /// Get primary color with custom opacity
  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity.clamp(0.0, 1.0));

  /// Get error color with custom opacity
  static Color errorWithOpacity(double opacity) =>
      error.withOpacity(opacity.clamp(0.0, 1.0));

  /// Get success color with custom opacity
  static Color successWithOpacity(double opacity) =>
      success.withOpacity(opacity.clamp(0.0, 1.0));

  /// Get warning color with custom opacity
  static Color warningWithOpacity(double opacity) =>
      warning.withOpacity(opacity.clamp(0.0, 1.0));

  //---------------------------------------------------------------------------
  // MATERIAL THEME COLOR SCHEMES
  //---------------------------------------------------------------------------

  /// Light Theme Color Scheme
  static ColorScheme get lightScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: background,
    secondary: success,
    onSecondary: background,
    tertiary: warning,
    onTertiary: background,
    error: error,
    onError: background,
    surface: background,
    onSurface: headingText,
    surfaceContainerHighest: secondarySurface,
    onSurfaceVariant: labelText,
    outline: borderGrey,
    outlineVariant: borderGrey,
    scrim: headingText,
    shadow: Color(0x1A000000),
    inverseSurface: headingText,
    onInverseSurface: background,
    primaryContainer: primary,
    onPrimaryContainer: background,
    secondaryContainer: success,
    onSecondaryContainer: background,
    tertiaryContainer: warning,
    onTertiaryContainer: background,
    errorContainer: error,
    onErrorContainer: background,
  );
}

extension AppColorExtensions on BuildContext {
  /// Get light theme color scheme
  ColorScheme get lightScheme => AppColors.lightScheme;
}
