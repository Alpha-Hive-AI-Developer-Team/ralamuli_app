import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get logoText => TextStyle(
    fontFamily: 'Scada',
    fontWeight: FontWeight.w400,
    fontSize: 24.sp,
    height: 22 / 24,
    letterSpacing: 0,
  );

  static TextStyle get headingXL => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 36.sp,
    height: 44 / 36,
    letterSpacing: -0.72,
  );

  /// Large Heading - 32px (OTP input, Large numbers)
  static TextStyle get headingLG => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 24.sp,
    height: 32 / 24,
    letterSpacing: 0,
  );

  /// Medium Heading - 20px (Section titles, Main content headings)
  static TextStyle get headingMD => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
    height: 30 / 20,
    letterSpacing: 0,
  );

  /// Small Heading - 18px (Card titles, Subsection headings)
  static TextStyle get headingSM => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 18.sp,
    height: 28 / 18,
    letterSpacing: 0,
  );

  // BODY STYLES - For main content and paragraphs

  /// Large Body Text - 16px Regular (Main content, Descriptions)
  static TextStyle get bodyLG => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 24 / 16,
    letterSpacing: 0,
  );

  /// Medium Body Text - 14px Regular (Supporting text, Details)
  static TextStyle get bodyMD => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 20 / 14,
    letterSpacing: 0,
  );

  /// Small Body Text - 12px Regular (Helper text, Footnotes)
  static TextStyle get bodySM => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    height: 18 / 12,
    letterSpacing: 0,
  );

  /// Large Label - 16px Medium (Form input text, Active states)
  static TextStyle get labelLG => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
    height: 24 / 16,
    letterSpacing: 0,
  );

  /// Medium Label - 14px Medium (Form labels, Table headers)
  static TextStyle get labelMD => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    height: 20 / 14,
    letterSpacing: 0,
  );

  /// Small Label - 12px Medium (Table labels, Category tags)
  static TextStyle get labelSM => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    height: 18 / 12,
    letterSpacing: 0,
  );

  /// Uppercase Caption - 12px Regular with spacing (Section headers, Metadata)
  static TextStyle get captionUppercase => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    height: 16 / 12,
    letterSpacing: 1.2,
  );

  /// Hint/Caption Text - 16px Regular (Input hints, Placeholder text)
  static TextStyle get captionHint => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 24 / 16,
    letterSpacing: 0,
  );

  // BUTTON STYLES - For interactive elements

  /// Large Button Text - 16px Semi-bold (Primary buttons)
  static TextStyle get buttonLG => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    height: 24 / 16,
    letterSpacing: 0,
  );

  /// Small Button Text - 14px Semi-bold (Secondary buttons, Text buttons)
  static TextStyle get buttonSM => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    height: 20 / 14,
    letterSpacing: 0,
  );

  //---------------------------------------------------------------------------
  // TABLE STYLES - For data tables and grids
  //---------------------------------------------------------------------------

  /// Table Header - 14px Medium (Column headers)
  static TextStyle get tableHeader => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    height: 20 / 14,
    letterSpacing: 0,
  );

  /// Table Cell - 14px Regular (Cell content)
  static TextStyle get tableCell => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 20 / 14,
    letterSpacing: 0,
  );

  /// Table Cell Small - 12px Medium (Compact table data)
  static TextStyle get tableCellSM => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    height: 18 / 12,
    letterSpacing: 0,
  );
}
