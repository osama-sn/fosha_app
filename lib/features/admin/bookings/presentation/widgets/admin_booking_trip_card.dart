import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminBookingTripCard extends StatelessWidget {
  final String title;
  final String duration;
  final String dates;
  final String imagePath;

  const AdminBookingTripCard({
    super.key,
    required this.title,
    required this.duration,
    required this.dates,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          AppNetworkImage(
            imageUrl: imagePath,
            width: 90.w,
            height: 75.h,
            fit: BoxFit.cover,
            borderRadius: AppSizes.r8,
          ),
          AppSizes.p12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSizes.p4.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.nightlight_round,
                      size: 14.r,
                      color: AppColors.textSecondary,
                    ),
                    AppSizes.p4.horizontalSpace,
                    Expanded(
                      child: Text(
                        duration,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                AppSizes.p4.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14.r,
                      color: AppColors.textSecondary,
                    ),
                    AppSizes.p4.horizontalSpace,
                    Expanded(
                      child: Text(
                        dates,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
