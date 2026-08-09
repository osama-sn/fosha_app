import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminFinancialsSection extends StatelessWidget {
  final double grossRevenue;
  final double adminCommissionPaid;

  const AdminFinancialsSection({
    super.key,
    required this.grossRevenue,
    required this.adminCommissionPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'البيانات المالية',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            AppSizes.p8.horizontalSpace,
            Icon(
              Icons.insert_chart_outlined,
              size: 20.r,
              color: AppColors.primaryDark,
            ),
          ],
        ),
        AppSizes.p12.verticalSpace,

        // 2 Side-by-side Cards
        Row(
          children: [
            // Card 1: Gross Sales (إجمالي المبيعات)
            Expanded(
              child: _buildFinancialCard(
                iconWidget: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.primary,
                    size: 20.r,
                  ),
                ),
                title: 'إجمالي المبيعات',
                value: '${grossRevenue.toStringAsFixed(0)} ج.م',
                valueColor: AppColors.primary,
                subtitle: 'إجمالي المبيعات الكلية',
              ),
            ),
            AppSizes.p12.horizontalSpace,

            // Card 2: Platform Commission (عمولة المنصة)
            Expanded(
              child: _buildFinancialCard(
                iconWidget: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Text(
                      '%',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: 'عمولة المنصة',
                value: '${adminCommissionPaid.toStringAsFixed(0)} ج.م',
                valueColor: AppColors.secondary,
                subtitle: 'إجمالي عمولة المنصة',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialCard({
    required Widget iconWidget,
    required String title,
    required String value,
    required Color valueColor,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.03),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          iconWidget,
          AppSizes.p12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSizes.p4.verticalSpace,
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                ),
                AppSizes.p2.verticalSpace,
                Text(
                  subtitle,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
