import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_card.dart';

class AdminBookingsList extends StatelessWidget {
  final List<BookingModel> bookings;
  final ValueChanged<String> onAcceptBooking;
  final ValueChanged<String> onRejectBooking;

  const AdminBookingsList({
    super.key,
    required this.bookings,
    required this.onAcceptBooking,
    required this.onRejectBooking,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.p32),
          child: Text(
            'لا توجد طلبات حجز حالياً',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ).expanded();
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppSizes.p20),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => AppSizes.p16.verticalSpace,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return AdminBookingCard(
          customerName: booking.customerName,
          customerEmail: booking.customerEmail,
          customerPhone: booking.customerPhone,
          tripTitle: booking.tripTitle,
          tripDates: booking.tripDates,
          totalAmount: '${booking.totalAmount.toStringAsFixed(0)} ج.م',
          passengersCount: '${booking.passengersCount} شخص',
          tripImage: booking.trip?.coverImage ?? '',
          status: booking.status == 'approved' ? 'accepted' : booking.status,
          onAccept: () => onAcceptBooking(booking.id),
          onReject: () => onRejectBooking(booking.id),
        );
      },
    ).expanded();
  }
}
