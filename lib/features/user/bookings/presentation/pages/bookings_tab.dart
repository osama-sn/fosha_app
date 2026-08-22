import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/user_bookings_cubit.dart';
import 'package:fosha_app/features/user/bookings/presentation/pages/user_booking_details_page.dart';
import 'package:fosha_app/features/user/bookings/presentation/widgets/user_booking_card.dart';

class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBookingsCubit>(
      create: (context) => getIt<UserBookingsCubit>()..fetchMyBookings(),
      child: const _BookingsTabBody(),
    );
  }
}

class _BookingsTabBody extends StatefulWidget {
  const _BookingsTabBody();

  @override
  State<_BookingsTabBody> createState() => _BookingsTabBodyState();
}

class _BookingsTabBodyState extends State<_BookingsTabBody> {
  int _selectedFilterIndex = 0;

  List<Map<String, String>> get _statusFilters => [
        {'title': AppStrings.adminAllMonths.replaceAll('الشهور', 'الكل'), 'value': 'all'},
        {'title': AppStrings.bookingStatusPending, 'value': 'pending'},
        {'title': AppStrings.bookingStatusConfirmed, 'value': 'approved'},
        {'title': AppStrings.bookingStatusRejected, 'value': 'rejected'},
        {'title': AppStrings.bookingStatusCancelled, 'value': 'cancelled'},
      ];

  @override
  Widget build(BuildContext context) {
    final filters = _statusFilters;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.adminBookingUnit,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          AppSizes.p12.verticalSpace,
          // Filter Chips Horizontal Bar
          SizedBox(
            height: 38.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (context, index) => AppSizes.p8.horizontalSpace,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                final filter = filters[index];
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedFilterIndex = index);
                    context
                        .read<UserBookingsCubit>()
                        .fetchMyBookings(status: filter['value']!);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      filter['title']!,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AppSizes.p16.verticalSpace,
          Expanded(
            child: BlocBuilder<UserBookingsCubit, UserBookingsState>(
              builder: (context, state) {
                if (state is UserBookingsLoading) {
                  return const Center(child: AppLoading());
                }

                if (state is UserBookingsFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.r,
                          color: AppColors.error,
                        ),
                        AppSizes.p12.verticalSpace,
                        Text(
                          state.error,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        AppSizes.p16.verticalSpace,
                        AppButton(
                          text: AppStrings.retry,
                          onPressed: () => context
                              .read<UserBookingsCubit>()
                              .fetchMyBookings(),
                        ),
                      ],
                    ),
                  );
                }

                if (state is UserBookingsLoaded) {
                  final bookings = state.bookings;
                  if (bookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.confirmation_number_outlined,
                            size: 64.r,
                            color: AppColors.textHint,
                          ),
                          AppSizes.p16.verticalSpace,
                          Text(
                            AppStrings.adminNoBookingsFound,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<UserBookingsCubit>().fetchMyBookings(
                            status: filters[_selectedFilterIndex]['value']!,
                          );
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                      itemCount: bookings.length,
                      separatorBuilder: (context, index) => AppSizes.p12.verticalSpace,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return UserBookingCard(
                          booking: booking,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    UserBookingDetailsPage(booking: booking),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
