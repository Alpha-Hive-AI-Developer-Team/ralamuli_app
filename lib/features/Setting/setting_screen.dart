import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ralamuli_translator/core/Routes/app_routes.dart';
import 'package:ralamuli_translator/core/Utils/app_strings.dart';
import 'package:ralamuli_translator/core/theme/app-colors.dart';
import 'package:ralamuli_translator/core/theme/text_styles.dart';
import 'package:ralamuli_translator/features/Setting/setting_notifier.dart';
import 'package:ralamuli_translator/features/Widgets/AppScaffold.dart';
import 'package:ralamuli_translator/features/Widgets/app_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return AppScaffold(
      child: SafeArea(
        child: GestureDetector(
          onTap: notifier.closeDropdown,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── App Bar ───────────────────────────────────────────
                  HelpingAppBar(title: "Settings"),
                  SizedBox(height: 24.h),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Default Language Card ─────────────────────
                          _DefaultLanguageCard(),
                          SizedBox(height: 24.h),

                          // ── About Section ─────────────────────────────
                          Text(
                            'About',
                            style: AppTextStyles.bodyMD.copyWith(
                              color: AppColors.bodyText_light,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _AboutCard(context: context),
                          SizedBox(height: 70.h),

                          // ── Illustration ──────────────────────────────
                          Center(
                            child: Image.asset(
                              settings,
                              width: 400.w,
                              height: 228.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ── Language Dropdown Overlay ─────────────────────────────
              if (state.isLanguageDropdownOpen) _LanguageDropdownOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Default Language Card ────────────────────────────────────────────────────

class _DefaultLanguageCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.borderGrey, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 26.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Default Language',
              style: AppTextStyles.bodyLG.copyWith(
                color: AppColors.bodyText,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: notifier.toggleDropdown,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: AppColors.borderGrey, width: 1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.defaultLanguage,
                      style: AppTextStyles.bodyMD.copyWith(
                        color: AppColors.bodyText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16.sp,
                      color: AppColors.bodyText_light,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── About Card ───────────────────────────────────────────────────────────────

class _AboutCard extends StatelessWidget {
  final BuildContext context;
  const _AboutCard({required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.borderGrey, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // App name & version
          _AboutRow(
            showDivider: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ralamuli Translator',
                  style: AppTextStyles.labelLG.copyWith(
                    color: AppColors.bodyText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Version 1.0.0',
                  style: AppTextStyles.bodySM.copyWith(
                    color: AppColors.bodyText_light,
                  ),
                ),
              ],
            ),
          ),

          // Offline mode
          _AboutRow(
            showDivider: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Offline Mode Active',
                      style: AppTextStyles.labelLG.copyWith(
                        color: AppColors.bodyText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Translations work without internet connection.',
                  style: AppTextStyles.bodyMD.copyWith(
                    color: AppColors.bodyText_light,
                  ),
                ),
              ],
            ),
          ),

          // Help & Support
          _AboutRow(
            onTap: () {
              context.push(AppRoutes.help);
            },
            showDivider: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Help & Support',
                      style: AppTextStyles.labelLG.copyWith(
                        color: AppColors.bodyText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Get help using the app',
                      style: AppTextStyles.bodyMD.copyWith(
                        color: AppColors.bodyText_light,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20.sp,
                  color: AppColors.bodyText_light,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final Widget child;
  final bool showDivider;
  final VoidCallback? onTap;

  const _AboutRow({required this.child, required this.showDivider, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Align(alignment: Alignment.centerLeft, child: child),
          ),
          if (showDivider)
            Divider(height: 1, thickness: 1, color: AppColors.borderGrey),
        ],
      ),
    );
  }
}

// ── Language Dropdown Overlay ────────────────────────────────────────────────

class _LanguageDropdownOverlay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(settingsProvider.notifier);
    final state = ref.watch(settingsProvider);

    return Positioned(
      top: 108.h, // below appbar + card top
      right: 20.w,
      child: GestureDetector(
        onTap: () {}, // prevent tap-through
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 150.w,
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.borderGrey, width: 1),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: SettingsNotifier.languages
                  .map(
                    (lang) => GestureDetector(
                      onTap: () => notifier.selectLanguage(lang),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: state.defaultLanguage == lang
                              ? AppColors.primaryWithOpacity(0.07)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          lang,
                          style: AppTextStyles.bodyMD.copyWith(
                            color: state.defaultLanguage == lang
                                ? AppColors.primary
                                : AppColors.bodyText,
                            fontWeight: state.defaultLanguage == lang
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
