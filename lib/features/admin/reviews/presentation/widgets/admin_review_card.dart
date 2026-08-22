import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/reviews/data/models/company_review_model.dart';

class AdminReviewCard extends StatelessWidget {
  final CompanyReviewModel review;

  const AdminReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    review.user.fullName.isNotEmpty
                        ? review.user.fullName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.user.fullName,
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (review.tripTitle != null &&
                          review.tripTitle!.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          '${AppStrings.adminTripTitleLabel}: ${review.tripTitle}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    SizedBox(width: 4.w),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Text(
                review.comment,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
