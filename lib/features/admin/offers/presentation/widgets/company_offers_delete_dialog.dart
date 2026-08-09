import 'package:flutter/material.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class CompanyOffersDeleteDialog extends StatelessWidget {
  final String offerTitle;
  final VoidCallback onConfirmDelete;

  const CompanyOffersDeleteDialog({
    super.key,
    required this.offerTitle,
    required this.onConfirmDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required String offerTitle,
    required VoidCallback onConfirmDelete,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => CompanyOffersDeleteDialog(
        offerTitle: offerTitle,
        onConfirmDelete: onConfirmDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppStrings.deleteOffer,
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        '${AppStrings.deleteOfferConfirm} "$offerTitle"؟',
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
