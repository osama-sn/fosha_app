import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminBookingsGrid extends StatelessWidget {
  final int totalBookings;
  final int approvedBookings;
  final int pendingBookings;
  final int rejectedBookings;

  const AdminBookingsGrid({
    super.key,
    required this.totalBookings,
    required this.approvedBookings,
    required this.pendingBookings,
    required this.rejectedBookings,
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
              'الحجوزات',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            AppSizes.p8.horizontalSpace,
            Icon(
              Icons.calendar_month_outlined,
              size: 20.r,
              color: AppColors.primaryDark,
            ),
          ],
        ),
        AppSizes.p12.verticalSpace,

        // Row of 4 Cards
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                iconData: Icons.work_outline,
                iconBgColor: const Color(0xFFE0F2FE),
                iconColor: const Color(0xFF0284C7),
                value: totalBookings.toString(),
                valueColor: const Color(0xFF0284C7),
                label: 'إجمالي الحجوزات',
              ),
            ),
            AppSizes.p8.horizontalSpace,
            Expanded(
              child: _buildMetricCard(
                context,
                iconData: Icons.check_circle_outline,
                iconBgColor: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF16A34A),
                value: approvedBookings.toString(),
                valueColor: const Color(0xFF16A34A),
                label: 'مقبولة',
              ),
            ),
            AppSizes.p8.horizontalSpace,
            Expanded(
              child: _buildMetricCard(
                context,
                iconData: Icons.access_time,
                iconBgColor: const Color(0xFFFFEDD5),
                iconColor: const Color(0xFFEA580C),
                value: pendingBookings.toString(),
                valueColor: const Color(0xFFEA580C),
                label: 'قيد الانتظار',
              ),
            ),
            AppSizes.p8.horizontalSpace,
            Expanded(
              child: _buildMetricCard(
                context,
                iconData: Icons.highlight_off,
                iconBgColor: const Color(0xFFFEE2E2),
                iconColor: const Color(0xFFDC2626),
                value: rejectedBookings.toString(),
                valueColor: const Color(0xFFDC2626),
                label: 'مرفوضة',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required IconData iconData,
    required Color iconBgColor,
    required Color iconColor,
    required String value,
    required Color valueColor,
    required String label,
  }) {
    return InkWell(
      onTap: () => context.push(RouteNames.adminBookings),
      borderRadius: BorderRadius.circular(AppSizes.r16),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSizes.p12, horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.03),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBgColor,
              ),
              child: Icon(iconData, color: iconColor, size: 18.r),
            ),
            AppSizes.p8.verticalSpace,
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ),
            AppSizes.p4.verticalSpace,
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
