import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ralamuli_translator/core/Utils/app_strings.dart';
import 'package:ralamuli_translator/core/Utils/screen_utils.dart';
import 'package:ralamuli_translator/core/theme/app-colors.dart';
import 'package:ralamuli_translator/core/theme/text_styles.dart';
import 'package:ralamuli_translator/features/Learning/Model/learning_model.dart';
import 'package:ralamuli_translator/features/Learning/Provider/learning_notifier.dart';
import 'package:ralamuli_translator/features/Learning/Provider/learning_state.dart';
import 'package:ralamuli_translator/features/Widgets/AppScaffold.dart';
import 'package:ralamuli_translator/features/Widgets/app_bar.dart';

class LearningModeScreen extends ConsumerWidget {
  const LearningModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learningProvider);

    return AppScaffold(
      child: SafeArea(
        child: Column(
          children: [
            // ── App Bar ───────────────────────────────────────────────
            HelpingAppBar(title: 'Learning Mode'),
            SizedBox(height: 16.h),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Progress Card ─────────────────────────────────
                    _ProgressCard(state: state),
                    SizedBox(height: ScreenUtils.vMd),

                    // ── Quiz Banner ───────────────────────────────────
                    _QuizBanner(),
                    SizedBox(height: 24.h),

                    // ── Word List Label ───────────────────────────────
                    Text(
                      'Word List',
                      style: AppTextStyles.headingSM.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.bodyText,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ── Word Cards ────────────────────────────────────
                    ...state.words.map((word) => _WordCard(word: word)),
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
// ─────────────────────────────────────────────────────────────────────────────
// PROGRESS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressCard extends StatelessWidget {
  final LearningState state;
  const _ProgressCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final percent = state.progressPercent;
    final percentInt = (percent * 100).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),

            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(232, 241, 255, 0.051),
                Color.fromRGBO(167, 200, 250, 0.051),
              ],
            ),

            // 🌟 Softer outer shadow
            boxShadow: [
              BoxShadow(
                color: const Color(0x0F356AB9),
                offset: const Offset(0, 8),
                blurRadius: 16,
              ),
            ],
          ),

          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(196, 220, 255, 0.35),
                  Color.fromRGBO(134, 178, 245, 0.35),
                ],
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.r),
                color: Colors.transparent,

                boxShadow: [
                  BoxShadow(
                    color: const Color(0x3397C1FF),
                    offset: const Offset(0, -1),
                    blurRadius: 2,
                  ),
                ],
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border_rounded,
                    size: 27.sp,
                    color: AppColors.blueText,
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Progress',
                        style: AppTextStyles.headingSM.copyWith(
                          color: AppColors.blueText,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${state.learnedCount} / ${state.totalCount} words learned',
                        style: AppTextStyles.bodyLG.copyWith(
                          color: AppColors.blueText.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '$percentInt%',
                    style: AppTextStyles.labelLG.copyWith(
                      color: AppColors.blueText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QUIZ BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _QuizBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          height: 220.h,
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.6),

            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.borderGrey.withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(soon, width: 145.w, height: 24.h),
              SizedBox(height: 5.h),

              Text(
                'Start Quiz (Coming Soon!)',
                style: AppTextStyles.labelLG.copyWith(
                  color: AppColors.headingText,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 4.h),

              Text(
                'Practice your learning with fun quizzes',
                style: AppTextStyles.bodyMD.copyWith(
                  color: AppColors.bodyText_light,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WORD CARD
// ─────────────────────────────────────────────────────────────────────────────

class _WordCard extends ConsumerWidget {
  final WordItem word;
  const _WordCard({required this.word});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(learningProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Image ─────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Image.network(
              word.imageUrl,
              width: double.infinity,
              height: 210.h,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
                  height: 160.h,
                  color: AppColors.secondarySurface,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 160.h,
                  color: AppColors.secondarySurface,
                  child: Icon(
                    Icons.image_outlined,
                    size: 36.sp,
                    color: AppColors.bodyText_light,
                  ),
                );
              },
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.borderGrey, width: 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
            child: Column(
              children: [
                // ── Ralamuli label ──────────────────────────────────
                Text(
                  'Ralamuli',
                  style: AppTextStyles.bodyMD.copyWith(
                    color: AppColors.bodyText_light,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  word.ralamuli,
                  style: AppTextStyles.headingSM.copyWith(
                    color: AppColors.headingText,
                  ),
                ),

                // ── English row ─────────────────────────────────────
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 18.w,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.borderGrey, width: 1),
                  ),
                  child: Column(
                    children: [
                      _TranslationRow(
                        language: 'English',
                        translation: word.english,
                      ),
                      SizedBox(height: 1.h),
                      Divider(color: AppColors.borderGrey, thickness: 0.5),
                      SizedBox(height: 1.h),

                      // ── Español row ─────────────────────────────────────
                      _TranslationRow(
                        language: 'Español',
                        translation: word.espanol,
                      ),
                    ],
                  ),
                ),
                // ── Mark as Learned / Learned button ───────────────
                _LearnedButton(
                  isLearned: word.isLearned,
                  onTap: () => notifier.toggleLearned(word.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TRANSLATION ROW
// ─────────────────────────────────────────────────────────────────────────────

class _TranslationRow extends StatelessWidget {
  final String language;
  final String translation;

  const _TranslationRow({required this.language, required this.translation});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          language,
          style: AppTextStyles.bodyLG.copyWith(color: AppColors.bodyText),
        ),
        Text(
          translation,
          style: AppTextStyles.bodyLG.copyWith(
            color: AppColors.headingText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEARNED BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _LearnedButton extends StatelessWidget {
  final bool isLearned;
  final VoidCallback onTap;

  const _LearnedButton({required this.isLearned, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isLearned
              ? const Color(0xFFE8F5E9)
              : AppColors.primaryWithOpacity(0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLearned) ...[
              Image.asset(check, width: 24.w, height: 24.h),
              SizedBox(width: 6.w),
            ],
            Text(
              isLearned ? 'Learned' : 'Mark as Learned',
              style: AppTextStyles.bodyLG.copyWith(
                color: isLearned ? AppColors.success : AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
