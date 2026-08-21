import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/core/utils/url_launcher_helper.dart';
import 'package:fosha_app/features/admin/customers/data/models/company_customer_model.dart';

class AdminCustomerCard extends StatelessWidget {
  final CompanyCustomerModel customer;
  final VoidCallback onOpenChat;

  const AdminCustomerCard({
    super.key,
    required this.customer,
    required this.onOpenChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  customer.fullName.isNotEmpty
                      ? customer.fullName[0].toUpperCase()
                      : 'C',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.fullName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (customer.phone.isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      Text(
                        customer.phone,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                    if (customer.email.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        customer.email,
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: onOpenChat,
                icon: const Icon(Icons.forum_rounded, color: Colors.indigo),
                tooltip: 'محادثة في التطبيق',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.indigo.withValues(alpha: 0.1),
                  padding: EdgeInsets.all(8.r),
                ),
              ),
              SizedBox(width: 4.w),
              if (customer.phone.isNotEmpty) ...[
                IconButton(
                  onPressed: () {
                    UrlLauncherHelper.launchWhatsApp(
                      context: context,
                      phone: customer.phone,
                      message:
                          'أهلاً بك أستاذ ${customer.fullName}، نتواصل معك من شركة السياحة عبر تطبيق فسحة.',
                    );
                  },
                  icon: const Icon(Icons.chat_bubble, color: AppColors.whatsApp),
                  tooltip: 'WhatsApp',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.whatsApp.withValues(alpha: 0.1),
                    padding: EdgeInsets.all(8.r),
                  ),
                ),
                SizedBox(width: 4.w),
                IconButton(
                  onPressed: () {
                    UrlLauncherHelper.makePhoneCall(
                      context: context,
                      phone: customer.phone,
                    );
                  },
                  icon: const Icon(Icons.phone_in_talk, color: AppColors.primary),
                  tooltip: 'اتصال',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    padding: EdgeInsets.all(8.r),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 14.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatMiniItem(
                  icon: Icons.confirmation_number_outlined,
                  iconColor: AppColors.primary,
                  label: 'عدد الحجوزات',
                  value: '${customer.totalBookings} رحلة',
                ),
                Container(
                  height: 28.h,
                  width: 1,
                  color: AppColors.border.withValues(alpha: 0.8),
                ),
                _buildStatMiniItem(
                  icon: Icons.payments_outlined,
                  iconColor: Colors.green.shade700,
                  label: 'إجمالي الإنفاق',
                  value: '${customer.totalSpent.toStringAsFixed(0)} ج.م',
                ),
              ],
            ),
          ),

          if (customer.previousTrips.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Text(
              'الرحلات التي حجزها العميل:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 6.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: customer.previousTrips.map((t) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.card_travel, size: 12.r, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text(
                        t.title,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatMiniItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20.r, color: iconColor),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
