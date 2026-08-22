import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/user_bookings_cubit.dart';
import 'package:fosha_app/features/user/bookings/presentation/widgets/user_booking_status_badge_widget.dart';
import 'package:fosha_app/features/chat/presentation/pages/chat_page.dart';

class UserBookingDetailsPage extends StatelessWidget {
  final BookingModel booking;

  const UserBookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBookingsCubit>(
      create: (context) => getIt<UserBookingsCubit>(),
      child: _UserBookingDetailsBody(booking: booking),
    );
  }
}

class _UserBookingDetailsBody extends StatelessWidget {
  final BookingModel booking;

  const _UserBookingDetailsBody({required this.booking});

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? AppColors.primaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripTitle = booking.trip?.title ?? AppStrings.adminDefaultTripTitle;
    final tripOrigin = booking.trip?.origin ?? '';
    final tripDest = booking.trip?.destination ?? '';
    final companyName = booking.companyName.isNotEmpty
        ? booking.companyName
        : AppStrings.userDefaultCompanyName;
    final bookingIdShort = booking.id.length >= 8
        ? booking.id.substring(booking.id.length - 8).toUpperCase()
        : booking.id;

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
          AppStrings.adminBookingUnit,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    bookingId: booking.id,
                    companyId: booking.companyId,
                    companyName: companyName,
                    tripId: booking.tripId,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            label: Text(
              AppStrings.contactWithCompany,
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          children: [
            // Status Card
            Container(
              padding: EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#$bookingIdShort',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        booking.createdAt != null
                            ? '${booking.createdAt!.year}-${booking.createdAt!.month}-${booking.createdAt!.day}'
                            : '',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  UserBookingStatusBadgeWidget(status: booking.status),
                ],
              ),
            ),
            AppSizes.p16.verticalSpace,
            // Trip Card Summary
            Container(
              padding: EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (booking.trip?.coverImage != null &&
                          booking.trip!.coverImage.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: AppNetworkImage(
                            imageUrl: booking.trip!.coverImage,
                            width: 64.r,
                            height: 64.r,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tripTitle,
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              companyName,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (tripOrigin.isNotEmpty || tripDest.isNotEmpty) ...[
                    const Divider(color: AppColors.border),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16.r,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '$tripOrigin ➔ $tripDest',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            AppSizes.p16.verticalSpace,
            // Financial & Payment Summary
            Container(
              padding: EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    AppStrings.adminSeatsCount,
                    '${booking.numberOfSeats} ${AppStrings.adminSeatUnit}',
                  ),
                  if (booking.paymentMethod.isNotEmpty)
                    _buildSummaryRow(
                      AppStrings.adminPaymentMethodLabel,
                      booking.paymentMethod,
                    ),
                  if (booking.paymentSenderInstaPay.isNotEmpty)
                    _buildSummaryRow(
                      'حساب انستا باي',
                      booking.paymentSenderInstaPay,
                    ),
                  if (booking.paymentSenderNumber.isNotEmpty)
                    _buildSummaryRow(
                      'رقم المحول منه',
                      booking.paymentSenderNumber,
                    ),
                  if (booking.pickupPoint.isNotEmpty)
                    _buildSummaryRow(
                      'نقطة التجمع',
                      booking.pickupPoint,
                    ),
                  if (booking.pickupTime.isNotEmpty)
                    _buildSummaryRow(
                      'موعد التجمع',
                      booking.pickupTime,
                    ),
                  const Divider(color: AppColors.border),
                  _buildSummaryRow(
                    AppStrings.adminTotalRevenue,
                    '${booking.totalPrice} ${AppStrings.currencyEGP}',
                    isBold: true,
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
