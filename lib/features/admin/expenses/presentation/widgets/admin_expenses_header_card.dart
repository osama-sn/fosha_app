import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminExpensesHeaderCard extends StatelessWidget {
  final double totalAmount;
  final int count;

  const AdminExpensesHeaderCard({
    super.key,
    required this.totalAmount,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.adminTotalExpenses,
            style: AppTextStyles.labelMedium.copyWith(color: Colors.white70),
          ),
          SizedBox(height: 6.h),
          Text(
            '${totalAmount.toStringAsFixed(0)} ${AppStrings.currencyEGP}',
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${AppStrings.adminRecordedExpensesCount}: $count',
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
