import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class CompanyProfileGovernoratePicker extends StatelessWidget {
  final String selectedGovernorate;
  final List<String> governoratesList;
  final ValueChanged<String> onChanged;

  const CompanyProfileGovernoratePicker({
    super.key,
    required this.selectedGovernorate,
    required this.governoratesList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveValue = governoratesList.contains(selectedGovernorate)
        ? selectedGovernorate
        : (governoratesList.isNotEmpty ? governoratesList.first : '');

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: effectiveValue.isNotEmpty ? effectiveValue : null,
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.primaryDark,
          ),
          items: governoratesList.map((String gov) {
            return DropdownMenuItem<String>(
              value: gov,
              child: Text(
                gov,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}
