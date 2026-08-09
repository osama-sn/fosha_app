import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';

class TripDetailsHeaderInfo extends StatelessWidget {
  final TripModel trip;

  const TripDetailsHeaderInfo({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                trip.title.isNotEmpty ? trip.title : 'شرم الشيخ - رحلة استجمام 5 أيام',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ],
        ),
        AppSizes.p8.verticalSpace,
        // Origin → Destination
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 16.r,
              color: AppColors.primaryDark,
            ),
            SizedBox(width: 4.w),
            Text(
              trip.origin.isNotEmpty ? trip.origin : 'القاهرة',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Icon(
                Icons.arrow_forward,
                size: 14.r,
                color: AppColors.textHint,
              ),
            ),
            Icon(
              Icons.flag_outlined,
              size: 16.r,
              color: AppColors.secondary,
            ),
            SizedBox(width: 4.w),
            Text(
              trip.destination.isNotEmpty ? trip.destination : 'شرم الشيخ',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSizes.p8.verticalSpace,
        Row(
          children: [
            Icon(Icons.star, color: AppColors.secondary, size: 18.sp),
            SizedBox(width: 4.w),
            Text(
              trip.averageRating > 0 ? trip.averageRating.toStringAsFixed(1) : '4.8',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '(${trip.reviewsCount > 0 ? trip.reviewsCount : 125} تقييم)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
            const Spacer(),
            if (trip.category != null &&
                (trip.category!.nameAr.isNotEmpty ||
                    trip.category!.nameEn.isNotEmpty))
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sailing,
                      size: 14.r,
                      color: AppColors.primaryDark,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      trip.category!.nameAr.isNotEmpty
                          ? trip.category!.nameAr
                          : trip.category!.nameEn,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        AppSizes.p12.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${trip.price > 0 ? trip.price.toStringAsFixed(0) : '2,450'} ج.م',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              '/ للشخص',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
