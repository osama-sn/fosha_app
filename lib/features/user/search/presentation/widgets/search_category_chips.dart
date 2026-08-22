import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
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

  List<SearchCategoryChipItem> get _items => [
        SearchCategoryChipItem(
          slug: 'all',
          label: AppStrings.allLabel,
          icon: Icons.grid_view,
        ),
        const SearchCategoryChipItem(
          slug: 'sea',
          label: 'بحرية',
          icon: Icons.sailing,
        ),
        const SearchCategoryChipItem(
          slug: 'safari',
          label: 'سفاري',
          icon: Icons.directions_car,
        ),
        const SearchCategoryChipItem(
          slug: 'religious',
          label: 'دينية',
          icon: Icons.mosque,
        ),
        const SearchCategoryChipItem(
          slug: 'historical',
          label: 'تاريخية',
          icon: Icons.account_balance,
        ),
        const SearchCategoryChipItem(
          slug: 'family',
          label: 'عائلية',
          icon: Icons.groups,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final effectiveSlug = (selectedSlug == null || selectedSlug!.isEmpty)
        ? 'all'
        : selectedSlug!;

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
        itemCount: items.length,
        separatorBuilder: (context, index) => AppSizes.p8.horizontalSpace,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = effectiveSlug == item.slug;

          return ChoiceChip(
            showCheckmark: false,
            avatar: Icon(
              item.icon,
              size: 16.r,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            label: Text(item.label),
            labelStyle: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            onSelected: (selected) {
              if (selected) {
                onCategorySelected(item.slug == 'all' ? null : item.slug);
              }
            },
          );
        },
      ),
    );
  }
}
