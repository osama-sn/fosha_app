import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';

import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/user/bookings/data/repositories/user_bookings_repository.dart';
import 'package:fosha_app/features/user/bookings/presentation/pages/user_booking_details_page.dart';

class TripDetailsStickyFooter extends StatelessWidget {
  final TripModel trip;

  const TripDetailsStickyFooter({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p20,
        vertical: AppSizes.p12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trip.price > 0 ? trip.price.toStringAsFixed(0) : '2,450'} ج.م',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppStrings.perPerson,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 180.w,
              height: 46.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: trip.isBooked
                      ? Colors.green.shade600
                      : AppColors.secondary, // Warm Orange
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 2,
                ),
                onPressed: () async {
                  if (trip.isBooked) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    );

                    try {
                      final repo = getIt<UserBookingsRepository>();
                      final bookingsResult = await repo.getMyBookings();
                      if (context.mounted) Navigator.pop(context);

                      BookingModel? matchingBooking;
                      bookingsResult.fold(
                        (_) {},
                        (bookingsList) {
                          for (final b in bookingsList) {
                            if (b.tripId == trip.id ||
                                (b.trip != null && b.trip!.id == trip.id)) {
                              matchingBooking = b;
                              break;
                            }
                          }
                        },
                      );

                      matchingBooking ??= BookingModel(
                        id: trip.id,
                        tripId: trip.id,
                        customerName: AppStrings.adminDefaultCustomerName,
                        customerEmail: '',
                        customerPhone: '',
                        tripTitle: trip.title,
                        tripDates: trip.durationText,
                        totalAmount: trip.price,
                        passengersCount: 1,
                        status: 'approved',
                        trip: BookingTripInfoModel(
                          id: trip.id,
                          title: trip.title,
                          coverImage: trip.coverImage,
                          startDate: trip.startDate,
                          endDate: trip.endDate,
                        ),
                        companyId: trip.companyId,
                        companyName: trip.companyName,
                      );

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserBookingDetailsPage(
                              booking: matchingBooking!,
                            ),
                          ),
                        );
                      }
                    } catch (_) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        final fallbackBooking = BookingModel(
                          id: trip.id,
                          tripId: trip.id,
                          customerName: AppStrings.adminDefaultCustomerName,
                          customerEmail: '',
                          customerPhone: '',
                          tripTitle: trip.title,
                          tripDates: trip.durationText,
                          totalAmount: trip.price,
                          passengersCount: 1,
                          status: 'approved',
                          trip: BookingTripInfoModel(
                            id: trip.id,
                            title: trip.title,
                            coverImage: trip.coverImage,
                            startDate: trip.startDate,
                            endDate: trip.endDate,
                          ),
                          companyId: trip.companyId,
                          companyName: trip.companyName,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserBookingDetailsPage(
                              booking: fallbackBooking,
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    context.push(
                      RouteNames.bookingConfirmation,
                      extra: trip,
                    );
                  }
                },
                child: Text(
                  trip.isBooked ? 'تم الحجز بالفعل ✓' : AppStrings.bookNow,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: trip.isBooked ? 14.sp : 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
