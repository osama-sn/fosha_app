import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminBookingStatusBanner extends StatelessWidget {
  final String status;

  const AdminBookingStatusBanner({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData iconData;
    String titleText;
    String descText;

    if (status == 'accepted' || status == 'approved') {
      bgColor = AppColors.success.withValues(alpha: 0.12);
      textColor = AppColors.success;
      iconData = Icons.check_circle;
      titleText = AppStrings.adminBookingAcceptedTitle;
      descText = AppStrings.adminBookingAcceptedDesc;
    } else if (status == 'rejected') {
      bgColor = AppColors.error.withValues(alpha: 0.12);
      textColor = AppColors.error;
      iconData = Icons.cancel;
      titleText = AppStrings.adminBookingRejectedTitle;
      descText = AppStrings.adminBookingRejectedDesc;
    } else {
      bgColor = AppColors.warning.withValues(alpha: 0.15);
      textColor = AppColors.warning;
      iconData = Icons.hourglass_top;
      titleText = AppStrings.adminBookingPendingTitle;
      descText = AppStrings.adminBookingPendingDesc;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.p8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: textColor, size: 24.r),
          ),
          AppSizes.p12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText,
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              2.h.verticalSpace,
              Text(
                descText,
                style: AppTextStyles.bodySmall.copyWith(
                  color: textColor.withValues(alpha: 0.85),
                ),
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }
}
