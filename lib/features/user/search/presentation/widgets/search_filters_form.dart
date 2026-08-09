import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_governorates.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/user/search/presentation/widgets/search_category_chips.dart';

class SearchFiltersForm extends StatelessWidget {
  final String? selectedGovernorate;
  final String? selectedDestination;
  final String? selectedCategory;
  final String? selectedCompanyId;
  final List<CompanyProfileModel> companies;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onDestinationChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onCompanyChanged;

  const SearchFiltersForm({
    super.key,
    required this.selectedGovernorate,
    required this.selectedDestination,
    required this.selectedCategory,
    required this.selectedCompanyId,
    required this.companies,
    required this.onGovernorateChanged,
    required this.onDestinationChanged,
    required this.onCategoryChanged,
    required this.onCompanyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. المحافظة
        Text(
          'المحافظة',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppSizes.p8.verticalSpace,
        _buildDropdown(
          value: (selectedGovernorate != null && selectedGovernorate!.isNotEmpty)
              ? selectedGovernorate
              : null,
          hint: AppStrings.selectGovernorateHint,
          icon: Icons.location_on_outlined,
          items: AppGovernorates.arabicNames,
          onChanged: onGovernorateChanged,
        ),
        AppSizes.p16.verticalSpace,

        // 2. الوجهة
        Text(
          'الوجهة',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppSizes.p8.verticalSpace,
        _buildDropdown(
          value: (selectedDestination != null && selectedDestination!.isNotEmpty)
              ? selectedDestination
              : null,
          hint: AppStrings.selectDestinationHint,
          icon: Icons.flight_land_outlined,
          items: AppGovernorates.arabicNames,
          onChanged: onDestinationChanged,
        ),
        AppSizes.p16.verticalSpace,

        // 3. الشركة
        Text(
          'الشركة',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppSizes.p8.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.p12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: (selectedCompanyId != null && selectedCompanyId!.isNotEmpty)
                  ? selectedCompanyId
                  : null,
              hint: Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    color: AppColors.textHint,
                    size: 20.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'اختر الشركة',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              items: companies.map((company) {
                return DropdownMenuItem<String>(
                  value: company.id,
                  child: Row(
                    children: [
                      Icon(
                        Icons.business_outlined,
                        color: AppColors.primaryDark,
                        size: 20.r,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          company.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onCompanyChanged,
            ),
          ),
        ),
        AppSizes.p16.verticalSpace,

        // 4. النوع
        Text(
          AppStrings.tripTypeLabel,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppSizes.p12.verticalSpace,
        SearchCategoryChips(
          selectedSlug: selectedCategory,
          onCategorySelected: onCategoryChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Row(
            children: [
              Icon(icon, color: AppColors.textHint, size: 20.r),
              SizedBox(width: 8.w),
              Text(
                hint,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primaryDark, size: 20.r),
                  SizedBox(width: 8.w),
                  Text(
                    item,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
