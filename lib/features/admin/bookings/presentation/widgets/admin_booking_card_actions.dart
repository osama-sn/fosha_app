import 'package:flutter/material.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/constants/admin_bookings_constants.dart';

class AdminBookingCardActions extends StatelessWidget {
  final String status;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const AdminBookingCardActions({
    super.key,
    required this.status,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    if (status == AdminBookingsConstants.statusPending) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onReject,
              icon: const Icon(Icons.close, color: AppColors.error),
              label: Text(
                AppStrings.adminRejectRequest,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: EdgeInsets.symmetric(vertical: AppSizes.p8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.p12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onAccept,
              icon: const Icon(Icons.check, color: AppColors.surface),
              label: Text(
                AppStrings.adminAcceptRequest,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: AppSizes.p8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final isAccepted = status == AdminBookingsConstants.statusAccepted ||
        status == AdminBookingsConstants.statusApproved;

    final bannerBg = (isAccepted ? AppColors.success : AppColors.error)
        .withValues(alpha: 0.08);
    final bannerBorder = (isAccepted ? AppColors.success : AppColors.error)
        .withValues(alpha: 0.3);
    final bannerTextColor = isAccepted ? AppColors.success : AppColors.error;
    final bannerText = isAccepted
        ? AppStrings.adminAcceptedBanner
        : AppStrings.adminRejectedBanner;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppSizes.p8),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(AppSizes.r8),
        border: Border.all(color: bannerBorder),
      ),
      child: Center(
        child: Text(
          bannerText,
          style: AppTextStyles.bodyMedium.copyWith(
            color: bannerTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
