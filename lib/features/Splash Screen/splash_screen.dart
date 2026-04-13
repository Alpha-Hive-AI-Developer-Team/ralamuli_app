import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ralamuli_translator/core/Routes/app_routes.dart';
import 'package:ralamuli_translator/core/Utils/app_strings.dart';
import 'package:ralamuli_translator/core/theme/app-colors.dart';
import 'package:ralamuli_translator/core/theme/text_styles.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // Start animation immediately on first frame
    _controller.forward();

    // Navigate after splash duration
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value.clamp(0.0, 1.0),
              child: Transform.scale(scale: _animation.value, child: child),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(logo, width: 127.w, height: 126.h),
              SizedBox(height: 25.h),
              Text(
                "Ralamuli Translator",
                style: AppTextStyles.logoText.copyWith(
                  color: AppColors.headingText,
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
