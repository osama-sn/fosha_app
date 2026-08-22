import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/expenses/data/constants/admin_expenses_constants.dart';
import 'package:fosha_app/features/admin/expenses/data/models/expense_model.dart';
import 'package:fosha_app/features/admin/expenses/presentation/widgets/receipt_preview_dialog.dart';

class AdminExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onDelete;

  const AdminExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryName =
        AdminExpensesConstants.categoriesMap[expense.category] ?? expense.category;
    final categoryIcon = AdminExpensesConstants.getCategoryIcon(expense.category);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(categoryIcon, color: Colors.red, size: 24.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        categoryName,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${expense.amount.toStringAsFixed(0)} ${AppStrings.currencyEGP}',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (expense.tripTitle != null && expense.tripTitle!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(Icons.explore_outlined,
                      size: 16, color: AppColors.primary),
                  SizedBox(width: 4.w),
                  Text(
                    '${AppStrings.adminLinkedToTrip}: ${expense.tripTitle}',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.primaryDark),
                  ),
                ],
              ),
            ],
            if (expense.notes.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                '${AppStrings.adminNotesPrefix}: ${expense.notes}',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (expense.receiptImage != null &&
                    expense.receiptImage!.isNotEmpty)
                  InkWell(
                    onTap: () {
                      ReceiptPreviewDialog.show(
                        context,
                        imageUrl: ApiEndpoints.getImageUrl(expense.receiptImage),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.image, size: 16, color: Colors.blue),
                        SizedBox(width: 4.w),
                        Text(
                          AppStrings.adminViewReceipt,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
