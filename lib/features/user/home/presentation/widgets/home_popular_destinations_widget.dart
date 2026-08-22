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

class HomePopularDestinationsWidget extends StatelessWidget {
  final List<TripModel> trips;
  final String title;
  final VoidCallback? onViewAll;

  const HomePopularDestinationsWidget({
    super.key,
    this.trips = const [],
    this.title = '',
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayTitle =
        title.isNotEmpty ? title : AppStrings.homePopularDestinations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  AppStrings.viewAll,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSizes.p12.verticalSpace,
        SizedBox(
          height: 180.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
            scrollDirection: Axis.horizontal,
            itemCount: trips.length,
            separatorBuilder: (context, index) => AppSizes.p12.horizontalSpace,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return DestinationCard(trip: trip);
            },
          ),
        ),
      ],
    );
  }
}

class DestinationCard extends StatefulWidget {
  final TripModel trip;

  const DestinationCard({super.key, required this.trip});

  @override
  State<DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.trip.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return GestureDetector(
      onTap: () => context.push(RouteNames.tripDetails, extra: trip),
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.r16),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: AppNetworkImage(
                    imageUrl: trip.fullCoverImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSizes.p10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSizes.p4.verticalSpace,
                  Text(
                    trip.destination,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10.sp,
                    ),
                  ),
                  AppSizes.p4.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${trip.price.toStringAsFixed(0)} ج.م',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          try {
                            final repo = getIt<FavoritesRepository>();
                            final isFavResult = await repo.toggleFavorite(trip.id);
                            isFavResult.fold(
                              (_) {},
                              (isFav) {
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
                              },
                            );
                          } catch (_) {}
                        },
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18.r,
                          color: _isFavorite ? Colors.red : AppColors.textHint,
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
    );
  }
}
