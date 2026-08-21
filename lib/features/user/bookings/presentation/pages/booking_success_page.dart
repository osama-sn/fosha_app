import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';

class BookingSuccessPage extends StatelessWidget {
  final BookingModel booking;

  const BookingSuccessPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.p20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppSizes.p24.verticalSpace,

              // Celebration Icon Header
              Container(
                width: 84.r,
                height: 84.r,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 48.r),
              ),
              AppSizes.p16.verticalSpace,
              Text(
                'تم حجز رحلتك بنجاح! 🎉',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSizes.p6.verticalSpace,
              Text(
                'نتمنى لك رحلة ممتعة وآمنة',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSizes.p20.verticalSpace,

              // Booking Details Card
              Container(
                padding: EdgeInsets.all(AppSizes.p16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.05),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: SizedBox(
                            width: 72.w,
                            height: 72.w,
                            child: AppNetworkImage(
                              imageUrl: booking.tripCoverImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.tripTitle.isNotEmpty
                                    ? booking.tripTitle
                                    : 'شرم الشيخ - رحلة استجمام',
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${booking.origin} ➔ ${booking.destination}',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSizes.p12.verticalSpace,
                    const Divider(color: AppColors.border, height: 1),
                    AppSizes.p12.verticalSpace,

                    // Booking Ref Number with Copy button
                    Container(
                      padding: EdgeInsets.all(AppSizes.p10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'رقم الحجز:',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                booking.id.length > 12
                                    ? 'FSH-${booking.id.substring(booking.id.length - 8).toUpperCase()}'
                                    : booking.id,
                                style: AppTextStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: booking.id),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم نسخ رقم الحجز'),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.copy,
                                  size: 16.r,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppSizes.p12.verticalSpace,

                    // Info List
                    _buildInfoRow(
                      Icons.groups_outlined,
                      'عدد الأفراد',
                      '${booking.numberOfSeats} أفراد',
                    ),
                    _buildInfoRow(
                      Icons.account_balance_wallet_outlined,
                      'الإجمالي',
                      '${booking.totalPrice.toStringAsFixed(0)} ج.م',
                    ),
                  ],
                ),
              ),
              AppSizes.p16.verticalSpace,

              // Success Alert Toast
              Container(
                padding: EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'تم إرسال تفاصيل الحجز إلى بريدك الإلكتروني ورقم هاتفك بنجاح',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSizes.p20.verticalSpace,

              // Action Options Header
              Text(
                'ماذا تريد أن تفعل الآن؟',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSizes.p12.verticalSpace,

              // Actions List Buttons
              _buildActionTile(
                icon: Icons.bookmark_outline,
                title: 'عرض حجوزاتي',
                onTap: () => context.go(RouteNames.home),
              ),
              AppSizes.p8.verticalSpace,
              _buildActionTile(
                icon: Icons.share_outlined,
                title: 'مشاركة الرحلة',
                onTap: () {},
              ),
              AppSizes.p8.verticalSpace,
              _buildActionTile(
                icon: Icons.home_outlined,
                title: 'العودة إلى الرئيسية',
                onTap: () => context.go(RouteNames.home),
              ),
              AppSizes.p24.verticalSpace,

              // Bottom Button
              AppButton(
                text: 'تحميل التذكرة / الإيصال 📄',
                onPressed: () => context.go(RouteNames.home),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.r, color: AppColors.textHint),
              SizedBox(width: 8.w),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryDark, size: 20.r),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.r,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
