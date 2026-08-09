import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/user/favorites/data/repositories/favorites_repository.dart';

class SearchResultsList extends StatelessWidget {
  final List<TripModel> trips;

  const SearchResultsList({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.p20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_outlined,
                size: 64.r,
                color: AppColors.textHint,
              ),
              AppSizes.p16.verticalSpace,
              Text(
                AppStrings.noTripsFound,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trips.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSizes.p16),
      itemBuilder: (context, index) {
        final trip = trips[index];
        return SearchTripCard(trip: trip);
      },
    );
  }
}

class SearchTripCard extends StatefulWidget {
  final TripModel trip;

  const SearchTripCard({super.key, required this.trip});

  @override
  State<SearchTripCard> createState() => _SearchTripCardState();
}

class _SearchTripCardState extends State<SearchTripCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return GestureDetector(
      onTap: () => context.push(RouteNames.tripDetails, extra: trip),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(16.r),
              ),
              child: SizedBox(
                width: 120.w,
                height: 110.h,
                child: AppNetworkImage(
                  imageUrl: trip.fullCoverImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            trip.title,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                            try {
                              final repo = getIt<FavoritesRepository>();
                              final isFav = await repo.toggleFavorite(trip.id);
                              setState(() {
                                _isFavorite = isFav;
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFav
                                          ? 'تمت إضافة الرحلة للمفضلة ❤️'
                                          : 'تمت إزالة الرحلة من المفضلة',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            } catch (_) {}
                          },
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18.r,
                            color:
                                _isFavorite ? Colors.red : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      trip.durationText.isNotEmpty
                          ? trip.durationText
                          : trip.destination,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${trip.price.toStringAsFixed(0)} ج.م',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (trip.averageRating > 0)
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.secondary,
                                size: 14.sp,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                trip.averageRating.toStringAsFixed(1),
                                style: AppTextStyles.labelSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
