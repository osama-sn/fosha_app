import 'package:flutter/material.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class CompanyCouponsDeleteDialog extends StatelessWidget {
  final String couponCode;
  final VoidCallback onConfirmDelete;

  const CompanyCouponsDeleteDialog({
    super.key,
    required this.couponCode,
    required this.onConfirmDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required String couponCode,
    required VoidCallback onConfirmDelete,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => CompanyCouponsDeleteDialog(
        couponCode: couponCode,
        onConfirmDelete: onConfirmDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppStrings.deleteCoupon,
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        '${AppStrings.deleteCouponConfirm} "$couponCode"؟',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmDelete();
          },
          child: Text(
            AppStrings.adminDeleteTrip,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}
