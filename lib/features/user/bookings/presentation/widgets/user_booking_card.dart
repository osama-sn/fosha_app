import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/user/bookings/presentation/widgets/user_booking_status_badge_widget.dart';

class UserBookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onTap;

  const UserBookingCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = booking.trip?.title.isNotEmpty == true
        ? booking.trip!.title
        : AppStrings.adminDefaultTripTitle;
    final coverImg = booking.trip?.coverImage ?? '';
    final bookingIdShort = booking.id.length >= 8
        ? booking.id.substring(booking.id.length - 8).toUpperCase()
        : booking.id;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (coverImg.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AppNetworkImage(
                      imageUrl: coverImg,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          UserBookingStatusBadgeWidget(status: booking.status),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '#$bookingIdShort',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSizes.p12.verticalSpace,
            const Divider(color: AppColors.border),
            AppSizes.p8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${booking.totalPrice} ${AppStrings.currencyEGP}',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppStrings.bookingsViewDetails,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
