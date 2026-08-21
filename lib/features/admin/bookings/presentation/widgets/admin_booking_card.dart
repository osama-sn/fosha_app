import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_card_actions.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_status_badge.dart';

class AdminBookingCard extends StatelessWidget {
  final BookingModel? booking;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String tripTitle;
  final String tripDates;
  final String totalAmount;
  final String passengersCount;
  final String tripImage;
  final String status;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onTap;

  const AdminBookingCard({
    super.key,
    this.booking,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.tripTitle,
    required this.tripDates,
    required this.totalAmount,
    required this.passengersCount,
    required this.tripImage,
    required this.status,
    this.onAccept,
    this.onReject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            context.push(RouteNames.adminBookingDetails, extra: booking);
          },
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdminBookingStatusBadge(status: status),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          customerName,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          customerEmail,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          customerPhone,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: AppSizes.p12),
                    Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border, width: 2),
                        color: AppColors.background,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 28.r,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSizes.p16),
            const Divider(height: 1, color: AppColors.divider),
            SizedBox(height: AppSizes.p16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        tripTitle,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSizes.p4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              tripDates,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: AppSizes.p4),
                          Icon(
                            Icons.calendar_today,
                            size: 12.r,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.p12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  AppStrings.adminPassengersCountLabel,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textHint,
                                    fontSize: 10.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  passengersCount,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: AppSizes.p16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  AppStrings.adminTotalAmountLabel,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textHint,
                                    fontSize: 10.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  totalAmount,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSizes.p16),
                AppNetworkImage(
                  imageUrl: tripImage,
                  width: 90.w,
                  height: 90.h,
                  fit: BoxFit.cover,
                  borderRadius: AppSizes.r8,
                ),
              ],
            ),
            SizedBox(height: AppSizes.p16),
            AdminBookingCardActions(
              status: status,
              onAccept: onAccept,
              onReject: onReject,
            ),
          ],
        ),
      ),
    );
  }
}
