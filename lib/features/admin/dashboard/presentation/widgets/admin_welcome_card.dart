import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/dashboard/data/models/stats_model.dart';

class AdminWelcomeCard extends StatelessWidget {
  final CompanyInfoModel? companyInfo;
  final String? companyName;

  const AdminWelcomeCard({
    super.key,
    this.companyInfo,
    this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = companyInfo?.name.isNotEmpty == true
        ? companyInfo!.name
        : (companyName?.isNotEmpty == true
            ? companyName!
            : AppStrings.adminWelcomeMessage);

    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.r12),
            ),
            child: Center(
              child: Icon(
                Icons.business_center,
                size: 22.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          AppSizes.p16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSizes.p4.verticalSpace,
              Text(
                AppStrings.adminDashboardTitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ).expanded(),
          if (companyInfo != null)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p8,
                vertical: AppSizes.p4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.r8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  AppSizes.p4.horizontalSpace,
                  Text(
                    'نشط',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: const Color(0xFF10B981),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}



