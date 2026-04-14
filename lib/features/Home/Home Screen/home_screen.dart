import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ralamuli_translator/core/Routes/app_routes.dart';
import 'package:ralamuli_translator/core/Utils/app_strings.dart';
import 'package:ralamuli_translator/core/Utils/screen_utils.dart';
import 'package:ralamuli_translator/core/theme/app-colors.dart';
import 'package:ralamuli_translator/core/theme/text_styles.dart';
import 'package:ralamuli_translator/features/Home/Home%20Provider/home_notifier.dart';
import 'package:ralamuli_translator/features/Home/Model/home_model.dart';
import 'package:ralamuli_translator/features/Widgets/AppScaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translatorState = ref.watch(translatorProvider);

    return AppScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AppBar(),
                        SizedBox(height: ScreenUtils.vXl),

                        _LanguageSelectorRow(),
                        SizedBox(height: ScreenUtils.vLg),

                        _InputCard(),
                        SizedBox(height: 18.h),

                        _SwapDivider(),
                        SizedBox(height: 18.h),

                        _OutputCard(),
                        SizedBox(height: 20.h),

                        _StartLearningBanner(),

                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),

                // Button stays fixed at bottom
                _TranslateButton(),
              ],
            ),

            // ── Language Dropdown Overlay ────────────────────────────────
            if (translatorState.isDropdownOpen) _LanguageDropdownOverlay(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _AppBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Logo icon
        Image.asset(logo, width: 60.w, height: 27.h),
        SizedBox(width: ScreenUtils.md),
        Text(
          'Ralamuli Translator',
          style: AppTextStyles.logoText.copyWith(color: AppColors.headingText),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            context.push(AppRoutes.settings);
          },
          child: Image.asset(setting, width: 24.w, height: 24.h),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LANGUAGE SELECTOR ROW
// ─────────────────────────────────────────────────────────────────────────────

class _LanguageSelectorRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(translatorProvider);
    final notifier = ref.read(translatorProvider.notifier);

    return Row(
      children: [
        // Source language dropdown button
        Expanded(
          child: _LanguageButton(
            label: state.sourceLanguage,
            onTap: () => notifier.openDropdown(isSource: true),
          ),
        ),
        SizedBox(width: 12.w),

        GestureDetector(
          onTap: notifier.swapLanguages,
          child: Image.asset(exchange, width: 24.w, height: 24.h),
        ),

        SizedBox(width: 12.w),
        // Target language dropdown button
        Expanded(
          child: _LanguageButton(
            label: state.targetLanguage,
            onTap: () => notifier.openDropdown(isSource: false),
          ),
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LanguageButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.md,
          vertical: ScreenUtils.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.borderGrey, width: 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.labelLG.copyWith(color: AppColors.labelText),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.sp,
              color: AppColors.bodyText_light,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INPUT CARD
// ─────────────────────────────────────────────────────────────────────────────

class _InputCard extends ConsumerStatefulWidget {
  @override
  ConsumerState<_InputCard> createState() => _InputCardState();
}

class _InputCardState extends ConsumerState<_InputCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(translatorProvider);
    final notifier = ref.read(translatorProvider.notifier);

    // Sync controller with state (e.g., after swap)
    if (_controller.text != state.inputText) {
      _controller.text = state.inputText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: state.inputText.length),
      );
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 200.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.borderGrey, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: notifier.updateInputText,
                        style: AppTextStyles.bodyLG.copyWith(
                          color: AppColors.bodyText,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter text',
                          hintStyle: AppTextStyles.bodyLG.copyWith(
                            color: AppColors.hintText,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                    if (state.inputText.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          _controller.clear();
                          notifier.clearInput();
                        },
                        child: Icon(
                          Icons.close,
                          size: 24.sp,
                          color: AppColors.bodyText,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(microphone, width: 24.w, height: 24.h),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SWAP DIVIDER
// ─────────────────────────────────────────────────────────────────────────────

class _SwapDivider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(translatorProvider);

    final bool isLoading = state.status == TranslationStatus.loading;

    // Arrow color: red on error, purple on success, grey otherwise
    Color arrowColor = AppColors.bodyText_light;
    if (state.status == TranslationStatus.error) {
      arrowColor = AppColors.error;
    } else if (state.status == TranslationStatus.success) {
      arrowColor = AppColors.primary;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 176.w, height: 1, color: arrowColor.withOpacity(0.3)),

        SizedBox(width: 10.w), // spacing

        isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Image.asset(translate, width: 24.w, height: 24.h),

        SizedBox(width: 10.w), // spacing

        Container(width: 176.w, height: 1, color: arrowColor.withOpacity(0.3)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OUTPUT CARD
// ─────────────────────────────────────────────────────────────────────────────

class _OutputCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(translatorProvider);

    final bool isError = state.status == TranslationStatus.error;
    final bool hasResult =
        state.status == TranslationStatus.success &&
        state.translatedText.isNotEmpty;

    final bool isLoading = state.status == TranslationStatus.loading;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 200.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: isError ? AppColors.error : AppColors.borderGrey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content
                  if (isError)
                    Text(
                      'Translation not available',
                      style: AppTextStyles.bodyLG.copyWith(
                        color: AppColors.error,
                      ),
                    )
                  else if (hasResult)
                    Text(
                      state.translatedText,
                      style: AppTextStyles.bodyLG.copyWith(
                        color: AppColors.bodyText,
                      ),
                    )
                  else if (isLoading)
                    Text(
                      'Loading...',
                      style: AppTextStyles.bodyLG.copyWith(
                        color: AppColors.hintText,
                      ),
                    )
                  else
                    Text(
                      'Translation will appear here.',
                      style: AppTextStyles.bodyLG.copyWith(
                        color: AppColors.hintText,
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: hasResult
                    ? () {
                        Clipboard.setData(
                          ClipboardData(text: state.translatedText),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    : null,
                child: Icon(
                  Icons.copy_outlined,
                  size: 20.sp,
                  color: hasResult
                      ? AppColors.bodyText_light
                      : Colors.transparent,
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
// START LEARNING BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _StartLearningBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(translatorProvider);

    final bool isEmpty = state.inputText.trim().isEmpty;
    return isEmpty
        ? GestureDetector(
            onTap: () {
              context.push(AppRoutes.learning);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFD8C9FF).withOpacity(0.5),
                    Color(0xFF6938EF).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Learning',
                            style: AppTextStyles.labelLG.copyWith(
                              color: AppColors.purpleText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Learn words in a simple and easy way',
                            style: AppTextStyles.bodySM.copyWith(
                              color: AppColors.purpleText.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.purpleText,
                      size: 25.sp,
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TRANSLATE BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _TranslateButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(translatorProvider);
    final notifier = ref.read(translatorProvider.notifier);

    final bool isLoading = state.status == TranslationStatus.loading;
    final bool hasInput = state.inputText.trim().isNotEmpty;
    final bool isEnabled = hasInput && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isEnabled ? notifier.translate : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppColors.primary
              : AppColors.disabledSurface,
          disabledBackgroundColor: AppColors.disabledSurface,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          isLoading ? 'Translate...' : 'Translate',
          style: AppTextStyles.buttonLG.copyWith(
            color: isEnabled ? Colors.white : AppColors.bodyText_light,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LANGUAGE DROPDOWN OVERLAY
// ─────────────────────────────────────────────────────────────────────────────

class _LanguageDropdownOverlay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(translatorProvider);
    final notifier = ref.read(translatorProvider.notifier);

    return GestureDetector(
      onTap: notifier.closeDropdown,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          // Tapping outside closes dropdown
          const SizedBox.expand(),
          // Dropdown card — positioned below language row
          Positioned(
            top: 98
                .h, // below appbar (16) + appbar height (~48) + gap (20) + lang row (~40) - 26
            left: state.isSelectingSource ? 20.w : null,
            right: state.isSelectingSource ? null : 20.w,
            child: GestureDetector(
              onTap: () {}, // prevent tap-through
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 160.w,
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
                    children: TranslatorNotifier.availableLanguages
                        .map(
                          (lang) => _DropdownItem(
                            label: lang,
                            isSelected: state.isSelectingSource
                                ? lang == state.sourceLanguage
                                : lang == state.targetLanguage,
                            onTap: () => notifier.selectLanguage(lang),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DropdownItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryWithOpacity(0.07)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMD.copyWith(
            color: isSelected ? AppColors.primary : AppColors.bodyText,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
