import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/features/admin/expenses/data/constants/admin_expenses_constants.dart';

class AdminExpensesCategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const AdminExpensesCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AdminExpensesConstants.categoriesMap.entries.map((entry) {
          final isSelected = selectedCategory == entry.key;
          return Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(entry.key);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
