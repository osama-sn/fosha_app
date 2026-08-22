import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminChatsEmptyView extends StatelessWidget {
  const AdminChatsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 72.r,
            color: AppColors.primary.withValues(alpha: 0.4),
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.adminNoChatsYet,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.adminNoChatsYetSub,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
