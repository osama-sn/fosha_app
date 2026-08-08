import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            Color(0xFF0F3854),
            Color(0xFF0E4C7A),
            Color(0xFF135A92),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E4C7A).withValues(alpha: 0.35),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Wallet icon in circular avatar
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
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
                  color: Colors.white.withValues(alpha: 0.9),
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
              Text(
                'بعد خصم عمولة المنصة',
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
