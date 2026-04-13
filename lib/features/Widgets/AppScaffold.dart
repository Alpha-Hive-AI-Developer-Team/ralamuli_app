import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ralamuli_translator/core/theme/app-colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: child,
        ),
      ),
    );
  }
}
