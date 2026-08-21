import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/features/admin/bookings/data/constants/admin_bookings_constants.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_card.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_bookings_empty_widget.dart';

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
      return const AdminBookingsEmptyWidget().expanded();
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppSizes.p20),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => AppSizes.p16.verticalSpace,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final status = booking.status == AdminBookingsConstants.statusApproved
            ? AdminBookingsConstants.statusAccepted
            : booking.status;

        return AdminBookingCard(
          booking: booking,
          customerName: booking.customerName,
          customerEmail: booking.customerEmail,
          customerPhone: booking.customerPhone,
          tripTitle: booking.tripTitle,
          tripDates: booking.tripDates,
          totalAmount:
              '${booking.totalAmount.toStringAsFixed(0)} ${AppStrings.adminCurrencyEGP}',
          passengersCount:
              '${booking.passengersCount} ${AppStrings.adminPersonUnit}',
          tripImage: booking.trip?.coverImage ?? '',
          status: status,
          onAccept: () => onAcceptBooking(booking.id),
          onReject: () => onRejectBooking(booking.id),
        );
      },
    ).expanded();
  }
}
