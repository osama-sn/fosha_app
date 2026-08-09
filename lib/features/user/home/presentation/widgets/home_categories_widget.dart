import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/categories/data/models/category_model.dart';

class HomeCategoriesWidget extends StatelessWidget {
  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel>? onCategorySelected;
  final VoidCallback? onViewAll;

  const HomeCategoriesWidget({
    super.key,
    this.categories = const [],
    this.onCategorySelected,
    this.onViewAll,
  });

  IconData _getCategoryIcon(String slug) {
    switch (slug.toLowerCase()) {
      case 'sea':
      case 'beach':
        return Icons.beach_access;
      case 'cultural':
      case 'historical':
        return Icons.account_balance;
      case 'safari':
      case 'adventure':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.attractions;
      default:
        return Icons.explore_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.homeCategories,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  AppStrings.viewAll,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSizes.p12.verticalSpace,
        SizedBox(
          height: 85.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => AppSizes.p12.horizontalSpace,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return InkWell(
                onTap: () {
                  if (onCategorySelected != null) {
                    onCategorySelected!(cat);
                  }
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Column(
                  children: [
                    Container(
                      width: 52.r,
                      height: 52.r,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: cat.image.isNotEmpty
                          ? ClipOval(
                              child: AppNetworkImage(
                                imageUrl: cat.image,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              _getCategoryIcon(cat.slug),
                              color: AppColors.primaryDark,
                              size: 24.r,
                            ),
                    ),
                    AppSizes.p6.verticalSpace,
                    Text(
                      cat.nameAr.isNotEmpty ? cat.nameAr : cat.nameEn,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
