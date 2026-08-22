import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminReviewsSummaryCard extends StatelessWidget {
  final double averageRating;
  final int totalReviews;

  const AdminReviewsSummaryCard({
    super.key,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade700,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < averageRating.floor()
                        ? Icons.star
                        : (index < averageRating
                            ? Icons.star_half
                            : Icons.star_border),
                    color: Colors.amber,
                    size: 18.r,
                  );
                }),
              ),
              SizedBox(height: 4.h),
              Text(
                '${AppStrings.adminTotalReviewsPrefix} $totalReviews ${AppStrings.adminReviewUnit}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.adminCustomerFeedbackHeader,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.adminCustomerFeedbackSub,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11.sp,
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
