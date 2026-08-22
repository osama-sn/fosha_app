import 'package:flutter/material.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';

class AdminExpensesDeleteDialog extends StatelessWidget {
  final VoidCallback onConfirmDelete;

  const AdminExpensesDeleteDialog({
    super.key,
    required this.onConfirmDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirmDelete,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AdminExpensesDeleteDialog(
        onConfirmDelete: () {
          Navigator.pop(dialogContext);
          onConfirmDelete();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.adminDeleteExpense),
      content: Text(AppStrings.adminConfirmDeleteExpense),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: onConfirmDelete,
          child: Text(
            AppStrings.adminDeleteExpense,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}
