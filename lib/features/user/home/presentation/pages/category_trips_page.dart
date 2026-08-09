import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/categories/data/models/category_model.dart';
import 'package:fosha_app/features/user/search/presentation/cubit/search_cubit.dart';
import 'package:fosha_app/features/user/search/presentation/cubit/search_state.dart';

class CategoryTripsPage extends StatelessWidget {
  final CategoryModel category;

  const CategoryTripsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) {
        final cubit = getIt<SearchCubit>();
        cubit.setCategory(category.slug);
        cubit.performSearch();
        return cubit;
      },
      child: _CategoryTripsBody(category: category),
    );
  }
}

class _CategoryTripsBody extends StatelessWidget {
  final CategoryModel category;

  const _CategoryTripsBody({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          category.nameAr.isNotEmpty ? category.nameAr : category.nameEn,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: AppLoading());
          }

          if (state is SearchFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 48.r,
                    ),
                    AppSizes.p16.verticalSpace,
                    Text(
                      state.error,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSizes.p24.verticalSpace,
                    AppButton(
                      text: 'إعادة المحاولة',
                      onPressed: () {
                        final cubit = context.read<SearchCubit>();
                        cubit.setCategory(category.slug);
                        cubit.performSearch();
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is SearchSuccess) {
            if (state.trips.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.p24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.travel_explore_outlined,
                        size: 64.r,
                        color: AppColors.textHint,
                      ),
                      AppSizes.p16.verticalSpace,
                      Text(
                        'لا توجد رحلات في هذا التصنيف حالياً',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p8.verticalSpace,
                      Text(
                        'جرّب تصفّح تصنيفات أخرى أو عد لاحقاً',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Results count header
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.p16,
                    AppSizes.p16,
                    AppSizes.p16,
                    AppSizes.p8,
                  ),
                  child: Text(
                    '${state.totalItems} رحلة متاحة',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                // Trips list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final cubit = context.read<SearchCubit>();
                      cubit.setCategory(category.slug);
                      await cubit.performSearch();
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.all(AppSizes.p16),
                      itemCount: state.trips.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSizes.p12),
                      itemBuilder: (context, index) {
                        final trip = state.trips[index];
                        return _CategoryTripCard(trip: trip);
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CategoryTripCard extends StatelessWidget {
  final TripModel trip;

  const _CategoryTripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(RouteNames.tripDetails, extra: trip);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.04),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Cover Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
              child: SizedBox(
                height: 160.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(
                      imageUrl: trip.fullCoverImageUrl,
                      fit: BoxFit.cover,
                    ),
                    // Category chip
                    if (trip.category != null)
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            trip.category!.nameAr.isNotEmpty
                                ? trip.category!.nameAr
                                : trip.category!.nameEn,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    // Available seats badge
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: trip.availableSeats > 5
                              ? Colors.green.withValues(alpha: 0.85)
                              : Colors.orange.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '${trip.availableSeats} مقعد متاح',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Trip Info
            Padding(
              padding: EdgeInsets.all(AppSizes.p12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),

                  // Origin -> Destination
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.r,
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${trip.origin} → ${trip.destination}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Date range
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14.r,
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDateRange(trip.startDate, trip.endDate),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Rating + Price row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.secondary,
                            size: 16.r,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            trip.averageRating > 0
                                ? trip.averageRating.toStringAsFixed(1)
                                : '4.5',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '(${trip.reviewsCount > 0 ? trip.reviewsCount : 0})',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textHint,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                      // Price
                      Text(
                        '${trip.price.toStringAsFixed(0)} ج.م',
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
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

  String _formatDateRange(String startDate, String endDate) {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      final months = [
        '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
      ];
      return '${start.day} ${months[start.month]} - ${end.day} ${months[end.month]} ${end.year}';
    } catch (_) {
      return '$startDate - $endDate';
    }
  }
}
