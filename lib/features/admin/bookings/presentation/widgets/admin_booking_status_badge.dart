import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/constants/admin_bookings_constants.dart';

class AdminBookingStatusBadge extends StatelessWidget {
  final String status;

  const AdminBookingStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case AdminBookingsConstants.statusAccepted:
      case AdminBookingsConstants.statusApproved:
        bg = AppColors.success.withValues(alpha: 0.12);
        text = AppColors.success;
        label = AppStrings.adminFilterAccepted;
        break;
      case AdminBookingsConstants.statusRejected:
        bg = AppColors.error.withValues(alpha: 0.12);
        text = AppColors.error;
        label = AppStrings.adminFilterRejected;
        break;
      case AdminBookingsConstants.statusPending:
      default:
        bg = AppColors.warning.withValues(alpha: 0.15);
        text = AppColors.warning;
        label = AppStrings.adminFilterPending;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p12, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: text,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
