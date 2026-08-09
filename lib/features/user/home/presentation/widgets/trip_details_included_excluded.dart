import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class TripDetailsIncludedExcluded extends StatelessWidget {
  final List<String> included;
  final List<String> excluded;

  const TripDetailsIncludedExcluded({
    super.key,
    this.included = const [
      'الإقامة في فندق 5 نجوم',
      'وجبة الإفطار يومياً',
      'المواصلات والتنقلات',
      'رحلات وجولات سياحية',
      'دليل سياحي',
    ],
    this.excluded = const [
      'تذاكر الطيران',
      'الوجبات غير المذكورة',
      'المصاريف الشخصية',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Included Card
        Container(
          padding: EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ماذا يشمل السعر',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Icon(Icons.unfold_less, size: 20.r, color: AppColors.textHint),
                ],
              ),
              AppSizes.p12.verticalSpace,
              ...included.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 18.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        item,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        AppSizes.p16.verticalSpace,

        // 2. Excluded Card
        Container(
          padding: EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ماذا لا يشمل السعر',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Icon(Icons.unfold_more, size: 20.r, color: AppColors.textHint),
                ],
              ),
              AppSizes.p12.verticalSpace,
              ...excluded.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: AppColors.error,
                        size: 18.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        item,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
