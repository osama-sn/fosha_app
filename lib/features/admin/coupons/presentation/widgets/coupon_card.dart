import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/coupons/data/models/coupon_model.dart';
import 'package:intl/intl.dart';

class CouponCard extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback onDelete;

  const CouponCard({
    super.key,
    required this.coupon,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Top Ticket Style Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p12,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDark,
                  AppColors.primaryDark.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  color: Colors.white,
                  size: 24.r,
                ),
                SizedBox(width: 8.w),
                // Coupon Code Badge
                Expanded(
                  child: Row(
                    children: [
                      SelectableText(
                        coupon.code,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 18.r,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: coupon.code));
                          AppSnackbar.showSuccess(
                            context: context,
                            message: '${AppStrings.copiedToClipboard} ${coupon.code}',
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Discount Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.p10,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'خصم ${coupon.discountPercentage.toStringAsFixed(0)}%',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Details
          Padding(
            padding: EdgeInsets.all(AppSizes.p16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoTile(
                      icon: Icons.money_off,
                      label: AppStrings.maxDiscountLabel,
                      value: coupon.maxDiscountAmount > 0
                          ? '${coupon.maxDiscountAmount.toStringAsFixed(0)} ج.م'
                          : 'بدون حد أقصى',
                    ),
                    _buildInfoTile(
                      icon: Icons.shopping_bag_outlined,
                      label: AppStrings.minTripPriceLabel,
                      value: coupon.minTripPrice > 0
                          ? '${coupon.minTripPrice.toStringAsFixed(0)} ج.م'
                          : 'بدون حد أدنى',
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoTile(
                      icon: Icons.event_available,
                      label: AppStrings.validUntilLabel,
                      value: dateFormat.format(coupon.validUntil),
                    ),
                    _buildInfoTile(
                      icon: Icons.people_outline,
                      label: AppStrings.usageLimitLabel,
                      value: coupon.usageLimit > 0
                          ? '${coupon.usedCount} من ${coupon.usageLimit}'
                          : '${coupon.usedCount} (غير محدود)',
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                const Divider(color: AppColors.border, height: 1),
                SizedBox(height: 8.h),

                // Delete Action
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18.r,
                      color: AppColors.error,
                    ),
                    label: Text(
                      AppStrings.deleteCoupon,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColors.primaryDark),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textHint,
                fontSize: 10.sp,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
