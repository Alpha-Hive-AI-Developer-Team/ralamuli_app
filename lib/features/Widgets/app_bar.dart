import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ralamuli_translator/core/theme/app-colors.dart';
import 'package:ralamuli_translator/core/theme/text_styles.dart';

class HelpingAppBar extends StatelessWidget {
  final String title;
  const HelpingAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Icon(
              Icons.chevron_left,
              size: 26.sp,
              color: AppColors.bodyText,
            ),
          ),
        ),
        Text(
          title,
          style: AppTextStyles.headingLG.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
