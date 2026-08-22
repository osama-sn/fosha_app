import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_strings.dart';

class AdminFinancialPeriodFilter extends StatelessWidget {
  final int? selectedMonth;
  final int? selectedYear;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;

  const AdminFinancialPeriodFilter({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int?>(
            initialValue: selectedMonth,
            decoration: InputDecoration(
              labelText: AppStrings.adminMonthLabel,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(AppStrings.adminAllMonths),
              ),
              ...List.generate(
                12,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text('${AppStrings.adminMonthPrefix} ${i + 1}'),
                ),
              ),
            ],
            onChanged: onMonthChanged,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: DropdownButtonFormField<int?>(
            initialValue: selectedYear,
            decoration: InputDecoration(
              labelText: AppStrings.adminYearLabel,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              border: const OutlineInputBorder(),
            ),
            items: [2024, 2025, 2026, 2027].map((y) {
              return DropdownMenuItem(
                value: y,
                child: Text('$y'),
              );
            }).toList(),
            onChanged: onYearChanged,
          ),
        ),
      ],
    );
  }
}
