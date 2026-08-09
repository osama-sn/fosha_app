import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class SearchCategoryChipItem {
  final String slug;
  final String label;
  final IconData icon;

  const SearchCategoryChipItem({
    required this.slug,
    required this.label,
    required this.icon,
  });
}

class SearchCategoryChips extends StatelessWidget {
  final String? selectedSlug;
  final ValueChanged<String?> onCategorySelected;

  const SearchCategoryChips({
    super.key,
    required this.selectedSlug,
    required this.onCategorySelected,
  });

  static const List<SearchCategoryChipItem> items = [
    SearchCategoryChipItem(
      slug: 'all',
      label: 'الكل',
      icon: Icons.grid_view,
    ),
    SearchCategoryChipItem(
      slug: 'sea',
      label: 'بحرية',
      icon: Icons.sailing,
    ),
    SearchCategoryChipItem(
      slug: 'safari',
      label: 'سفاري',
      icon: Icons.directions_car,
    ),
    SearchCategoryChipItem(
      slug: 'religious',
      label: 'دينية',
      icon: Icons.mosque,
    ),
    SearchCategoryChipItem(
      slug: 'historical',
      label: 'تاريخية',
      icon: Icons.account_balance,
    ),
    SearchCategoryChipItem(
      slug: 'family',
      label: 'عائلية',
      icon: Icons.groups,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final effectiveSlug = (selectedSlug == null || selectedSlug!.isEmpty)
        ? 'all'
        : selectedSlug;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final isSelected = item.slug == effectiveSlug;
          return Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: GestureDetector(
              onTap: () {
                onCategorySelected(item.slug == 'all' ? null : item.slug);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 68.w,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryDark : AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryDark : AppColors.border,
                  ),
                  boxShadow: [
                    if (!isSelected)
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.04),
                        blurRadius: 6.r,
                        offset: Offset(0, 2.h),
                      ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 22.r,
                      color: isSelected ? Colors.white : AppColors.primaryDark,
                    ),
                    AppSizes.p6.verticalSpace,
                    Text(
                      item.label,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 11.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
