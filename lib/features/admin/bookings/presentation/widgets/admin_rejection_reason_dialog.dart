import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminRejectionReasonDialog extends StatelessWidget {
  final ValueChanged<String?> onConfirmRejection;

  const AdminRejectionReasonDialog({
    super.key,
    required this.onConfirmRejection,
  });

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<String?> onConfirmRejection,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AdminRejectionReasonDialog(
        onConfirmRejection: onConfirmRejection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reasonController = TextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      title: Text(
        AppStrings.adminRejectDialogTitle,
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.adminRejectDialogSubtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSizes.p12.verticalSpace,
          TextField(
            controller: reasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: AppStrings.adminRejectDialogHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.r8),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
          onPressed: () {
            final reason = reasonController.text.trim();
            Navigator.pop(context);
            onConfirmRejection(reason.isNotEmpty ? reason : null);
          },
          child: Text(
            AppStrings.adminRejectDialogConfirm,
            style: const TextStyle(color: AppColors.surface),
          ),
        ),
      ],
    );
  }
}
