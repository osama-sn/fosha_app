import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class TripDetailsReviews extends StatelessWidget {
  final double averageRating;
  final int reviewsCount;

  const TripDetailsReviews({
    super.key,
    this.averageRating = 4.8,
    this.reviewsCount = 125,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تقييمات الرحلة',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppSizes.p12.verticalSpace,

        // Overall Score & Bars
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.secondary, size: 24.sp),
                    SizedBox(width: 4.w),
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '($reviewsCount تقييم)',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                children: [
                  _buildRatingBar(5, 0.85, 85),
                  _buildRatingBar(4, 0.28, 28),
                  _buildRatingBar(3, 0.08, 8),
                  _buildRatingBar(2, 0.03, 3),
                  _buildRatingBar(1, 0.01, 1),
                ],
              ),
            ),
          ],
        ),
        AppSizes.p16.verticalSpace,

        // Individual Reviews Cards
        _buildUserReviewItem(
          name: 'أحمد محمد',
          date: 'منذ أسبوع',
          rating: 5,
          comment:
              'رحلة رائعة. جداً. التنظيم ممتاز والفندق كان أكثر من رائع، أنصح الجميع بتجربة هذه الرحلة.',
        ),
        AppSizes.p12.verticalSpace,
        _buildUserReviewItem(
          name: 'سارة أحمد',
          date: 'منذ أسبوعين',
          rating: 4,
          comment: 'تجربة ممتازة والرحلة البحرية كانت ممتعة جداً.',
        ),
      ],
    );
  }

  Widget _buildRatingBar(int stars, double factor, int count) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Text(
            '$stars',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(width: 2.w),
          Icon(Icons.star, color: AppColors.secondary, size: 10.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: factor,
                minHeight: 6.h,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.secondary,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '$count',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textHint,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserReviewItem({
    required String name,
    required String date,
    required int rating,
    required String comment,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primaryDark,
                      size: 16.r,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        date,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    size: 14.sp,
                    color: index < rating ? AppColors.secondary : AppColors.border,
                  );
                }),
              ),
            ],
          ),
          AppSizes.p8.verticalSpace,
          Text(
            comment,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
