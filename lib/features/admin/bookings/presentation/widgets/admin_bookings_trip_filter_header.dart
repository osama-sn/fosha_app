import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminBookingsTripFilterHeader extends StatelessWidget {
  final String selectedTrip;
  final List<String> tripOptions;
  final ValueChanged<String> onTripChanged;

  const AdminBookingsTripFilterHeader({
    super.key,
    required this.selectedTrip,
    required this.tripOptions,
    required this.onTripChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p8,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_alt_outlined,
            size: 20.r,
            color: AppColors.primary,
          ),
          AppSizes.p8.horizontalSpace,
          Text(
            AppStrings.adminFilterByTripHeader,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          AppSizes.p12.horizontalSpace,
          Container(
            height: 38.h,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.r8),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedTrip,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20.r,
                  color: AppColors.primary,
                ),
                items: tripOptions.map((trip) {
                  return DropdownMenuItem<String>(
                    value: trip,
                    child: Text(
                      trip,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    onTripChanged(val);
                  }
                },
              ),
            ),
          ).expanded(),
        ],
      ),
    );
  }
}
