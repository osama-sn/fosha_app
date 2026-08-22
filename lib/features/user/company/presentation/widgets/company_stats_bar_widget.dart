import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class CompanyStatsBarWidget extends StatelessWidget {
  final int? tripsCount;
  final int reviewsCount;
  final String? governorate;

  const CompanyStatsBarWidget({
    super.key,
    this.tripsCount,
    required this.reviewsCount,
    this.governorate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildStatColumn(
            '${tripsCount ?? '-'} ${AppStrings.tabTrips}',
            AppStrings.tabTrips,
          ),
          Container(
            width: 1,
            height: 30.h,
            color: AppColors.border,
          ),
          _buildStatColumn(
            '${reviewsCount > 0 ? reviewsCount : '-'} ${AppStrings.adminReviewUnit}',
            AppStrings.adminReviewsTitle,
          ),
          Container(
            width: 1,
            height: 30.h,
            color: AppColors.border,
          ),
          _buildStatColumn(
            governorate ?? '-',
            AppStrings.governorateLabel,
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String val, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            val,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textHint,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
