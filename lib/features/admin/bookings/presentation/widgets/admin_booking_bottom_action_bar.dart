import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminBookingBottomActionBar extends StatelessWidget {
  final String customerPhone;
  final VoidCallback onCancelBooking;

  const AdminBookingBottomActionBar({
    super.key,
    required this.customerPhone,
    required this.onCancelBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 10.r,
            offset: Offset(0, -3.h),
          ),
        ],
      ),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: onCancelBooking,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            label: Text(
              AppStrings.adminCancelBooking,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              padding: EdgeInsets.symmetric(vertical: AppSizes.p12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
            ),
          ).expanded(),
          AppSizes.p16.horizontalSpace,
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('جاري الاتصال بالعميل على رقم $customerPhone...'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            icon: const Icon(Icons.headset_mic_outlined, color: Colors.white),
            label: Text(
              AppStrings.adminContactCustomer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: AppSizes.p12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
            ),
          ).expanded(),
        ],
      ),
    );
  }
}
