import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminSubscriptionCard extends StatelessWidget {
  final double monthlySubscriptionFee;
  final double commissionValue;

  const AdminSubscriptionCard({
    super.key,
    required this.monthlySubscriptionFee,
    required this.commissionValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'الاشتراك والعمولة',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            AppSizes.p8.horizontalSpace,
            Icon(
              Icons.workspace_premium_outlined,
              size: 20.r,
              color: AppColors.primaryDark,
            ),
          ],
        ),
        AppSizes.p12.verticalSpace,

        // Single Card with 3 Columns
        Container(
          padding: EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.r16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.03),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            children: [
              // Column 1: Active Status Chip
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.p12,
                        vertical: AppSizes.p6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppSizes.r20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 14.r,
                            color: AppColors.success,
                          ),
                          AppSizes.p4.horizontalSpace,
                          Text(
                            'نشط',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSizes.p8.verticalSpace,
                    Text(
                      'الاشتراك فعال',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 1,
                height: 45.h,
                color: AppColors.divider,
              ),

              // Column 2: Monthly Fee
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                        size: 16.r,
                      ),
                    ),
                    AppSizes.p6.verticalSpace,
                    Text(
                      'الاشتراك الشهري',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                      ),
                    ),
                    AppSizes.p2.verticalSpace,
                    Text(
                      '${monthlySubscriptionFee.toStringAsFixed(0)} ج.م',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 1,
                height: 45.h,
                color: AppColors.divider,
              ),

              // Column 3: Platform Commission
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary.withValues(alpha: 0.15),
                      ),
                      child: Center(
                        child: Text(
                          '%',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    AppSizes.p6.verticalSpace,
                    Text(
                      'عمولة المنصة',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                      ),
                    ),
                    AppSizes.p2.verticalSpace,
                    Text(
                      '${commissionValue.toStringAsFixed(0)}%',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
