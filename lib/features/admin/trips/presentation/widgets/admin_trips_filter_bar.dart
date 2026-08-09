import 'package:flutter/material.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminTripsFilterBar extends StatelessWidget {
  final List<String?> filters;
  final int selectedIndex;
  final String Function(String? status) getStatusLabel;
  final ValueChanged<int> onFilterSelected;

  const AdminTripsFilterBar({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.getStatusLabel,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
        child: Row(
          children: List.generate(
            filters.length,
            (index) => _buildFilterTab(
              label: getStatusLabel(filters[index]),
              isSelected: selectedIndex == index,
              onTap: () => onFilterSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.titleSmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
