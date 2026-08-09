import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_assets.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminWelcomeSection extends StatelessWidget {
  const AdminWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Illustration image on left (transparent PNG)
        Image.asset(
          AppAssets.registerIllustration,
          height: 85.h,
          fit: BoxFit.contain,
        ),

        // Welcome text on right
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppStrings.welcomeBack,
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            AppSizes.p4.verticalSpace,
            Text(
              AppStrings.companyPerformanceSummary,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
