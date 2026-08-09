import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminNetProfitCard extends StatelessWidget {
  final double netRevenue;

  const AdminNetProfitCard({super.key, required this.netRevenue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.3),
            blurRadius: 14.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Wallet icon in elegant golden tinted avatar
          Container(
            width: 54.r,
            height: 54.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.2),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.secondaryLight,
              size: 26.r,
            ),
          ),

          // Right: Text details
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'صافي أرباح الشركة',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSizes.p4.verticalSpace,
              Text(
                '${netRevenue.toStringAsFixed(0)} ج.م',
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24.sp,
                ),
              ),
              AppSizes.p4.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'بعد استقطاع عمولة المنصة',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.secondaryLight,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
