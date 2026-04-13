import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ralamuli_translator/core/theme/app-colors.dart';
import 'package:ralamuli_translator/core/theme/text_styles.dart';
import 'package:ralamuli_translator/features/Widgets/AppScaffold.dart';
import 'package:ralamuli_translator/features/Widgets/app_bar.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SafeArea(
        child: Column(
          children: [
            // ── App Bar ───────────────────────────────────────────────
            HelpingAppBar(title: "Help & Support"),
            SizedBox(height: 24.h),

            // ── Content ───────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _HelpCard(
                      title: 'How to Translate',
                      items: const [
                        '1. Select your languages at the top.',
                        '2. Type or use the microphone to enter text.',
                        '3. Tap the Translate button.',
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _HelpCard(
                      title: 'Offline Mode',
                      body:
                          "This app works completely offline. You don't need an internet connection to translate words.",
                    ),
                    SizedBox(height: 12.h),
                    _HelpCard(
                      title: 'Voice Input',
                      body:
                          'Tap the microphone icon to speak your word. Note: Voice input is currently not available for Ralamuli.',
                    ),
                    SizedBox(height: 12.h),
                    _HelpCard(
                      title: 'Contact Us',
                      body:
                          'For additional support or to suggest new words, please contact your local community center or teacher.',
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

class _HelpCard extends StatelessWidget {
  final String title;
  final List<String>? items;
  final String? body;

  const _HelpCard({required this.title, this.items, this.body})
    : assert(items != null || body != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.borderGrey, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headingSM.copyWith(
              color: AppColors.bodyText,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),
          if (items != null)
            ...items!.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  item,
                  style: AppTextStyles.bodyMD.copyWith(
                    color: AppColors.bodyText_light,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            )
          else if (body != null)
            Text(
              body!,
              style: AppTextStyles.bodyMD.copyWith(
                color: AppColors.bodyText_light,
                fontSize: 16.sp,
              ),
            ),
        ],
      ),
    );
  }
}
