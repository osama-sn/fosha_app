import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';

class HomeFeaturedBannerWidget extends StatelessWidget {
  final List<TripModel> trips;

  const HomeFeaturedBannerWidget({super.key, this.trips = const []});

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return const SizedBox.shrink();
    }

    final featuredTrip = trips.first;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: GestureDetector(
        onTap: () => context.push(RouteNames.tripDetails, extra: featuredTrip),
        child: Container(
          height: 160.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.r16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.08),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: AppNetworkImage(
                  imageUrl: featuredTrip.fullCoverImageUrl,
                  borderRadius: AppSizes.r16,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.r16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.p10,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'رحلة مميزة ⭐',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            featuredTrip.title,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppSizes.p4.verticalSpace,
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white70,
                                size: 12.sp,
                              ),
                              AppSizes.p4.horizontalSpace,
                              Text(
                                featuredTrip.durationText.isNotEmpty
                                    ? featuredTrip.durationText
                                    : featuredTrip.destination,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white70,
                                  fontSize: 11.sp,
                                ),
                              ),
                              if (featuredTrip.averageRating > 0) ...[
                                AppSizes.p12.horizontalSpace,
                                Icon(
                                  Icons.star,
                                  color: AppColors.secondary,
                                  size: 14.sp,
                                ),
                                AppSizes.p4.horizontalSpace,
                                Text(
                                  featuredTrip.averageRating.toStringAsFixed(1),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${featuredTrip.price.toStringAsFixed(0)} ج.م',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AppSizes.p4.verticalSpace,
                        SizedBox(
                          height: 30.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              minimumSize: Size(0, 30.h),
                            ),
                            onPressed: () => context.push(
                              RouteNames.tripDetails,
                              extra: featuredTrip,
                            ),
                            child: Text(
                              AppStrings.bookNow,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
