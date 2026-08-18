import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/user_bookings_cubit.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/user_bookings_state.dart';
import 'package:fosha_app/features/user/bookings/presentation/pages/user_booking_details_page.dart';

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

  final List<Map<String, String>> _statusFilters = const [
    {'title': 'الكل', 'value': 'all'},
    {'title': 'قيد الانتظار', 'value': 'pending'},
    {'title': 'المؤكدة', 'value': 'approved'},
    {'title': 'المرفوضة', 'value': 'rejected'},
    {'title': 'الملغاة', 'value': 'cancelled'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
          onPressed: () {},
        ),
        title: Text(
          'حجوزاتي',
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
              itemCount: _statusFilters.length,
              separatorBuilder: (context, index) =>
                  AppSizes.p8.horizontalSpace,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                final filter = _statusFilters[index];
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
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryDark
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.border,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filter['title']!,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AppSizes.p12.verticalSpace,

          // Bookings List
          Expanded(
            child: BlocBuilder<UserBookingsCubit, UserBookingsState>(
              builder: (context, state) {
                if (state is UserBookingsLoading) {
                  return const Center(child: AppLoading());
                }

                if (state is UserBookingsFailure) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.p20),
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
                          ),
                          AppSizes.p24.verticalSpace,
                          AppButton(
                            text: AppStrings.retry,
                            onPressed: () => context
                                .read<UserBookingsCubit>()
                                .fetchMyBookings(
                                  status: _statusFilters[_selectedFilterIndex]
                                      ['value']!,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is UserBookingsLoaded) {
                  if (state.bookings.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.p24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark_border_outlined,
                              size: 64.r,
                              color: AppColors.textHint,
                            ),
                            AppSizes.p16.verticalSpace,
                            Text(
                              'لا توجد حجوزات في هذه القائمة',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<UserBookingsCubit>()
                        .fetchMyBookings(
                          status: _statusFilters[_selectedFilterIndex]['value']!,
                        ),
                    child: ListView.separated(
                      padding: EdgeInsets.all(AppSizes.p16),
                      itemCount: state.bookings.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSizes.p12),
                      itemBuilder: (context, index) {
                        final booking = state.bookings[index];
                        return _buildBookingCard(context, booking);
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

  Widget _buildBookingCard(BuildContext context, BookingModel booking) {
    Color statusColor;
    String statusText;
    switch (booking.status.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
      case 'approved':
        statusColor = Colors.green;
        statusText = 'مؤكدة';
        break;
      case 'pending':
      case 'pending_verification':
        statusColor = Colors.orange;
        statusText = 'قيد الانتظار';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'مرفوضة';
        break;
      case 'cancelled':
        statusColor = Colors.grey;
        statusText = 'ملغاة';
        break;
      default:
        statusColor = AppColors.primaryDark;
        statusText = booking.status;
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserBookingDetailsPage(booking: booking),
          ),
        );
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(16.r),
              ),
              child: SizedBox(
                width: 110.w,
                height: 120.h,
                child: AppNetworkImage(
                  imageUrl: booking.tripCoverImage,
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
                            booking.tripTitle.isNotEmpty
                                ? booking.tripTitle
                                : 'شرم الشيخ - رحلات استجمام',
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            statusText,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      booking.tripDates.isNotEmpty
                          ? booking.tripDates
                          : '15 - 19 مايو 2026',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${booking.totalPrice.toStringAsFixed(0)} ج.م',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '#FSH-${booking.id.substring(booking.id.length > 8 ? booking.id.length - 8 : 0).toUpperCase()}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textHint,
                            fontSize: 10.sp,
                          ),
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
