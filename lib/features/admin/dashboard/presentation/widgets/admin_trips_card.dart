import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminTripsCard extends StatelessWidget {
  final int totalTrips;
  final int publishedTrips;
  final int draftTrips;

  const AdminTripsCard({
    super.key,
    required this.totalTrips,
    required this.publishedTrips,
    required this.draftTrips,
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
              'الرحلات',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            AppSizes.p8.horizontalSpace,
            Icon(
              Icons.work_outline,
              size: 20.r,
              color: AppColors.primaryDark,
            ),
          ],
        ),
        AppSizes.p12.verticalSpace,

        // Surface Card containing 3 list rows
        InkWell(
          onTap: () => context.push(RouteNames.adminTrips),
          borderRadius: BorderRadius.circular(AppSizes.r16),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p8,
            ),
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
            child: Column(
              children: [
                _buildTripRow(
                  iconData: Icons.work_outline,
                  iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                  iconColor: AppColors.primary,
                  title: 'إجمالي الرحلات',
                  value: totalTrips.toString(),
                  valueColor: AppColors.primary,
                ),
                const Divider(height: 1, color: AppColors.divider),
                _buildTripRow(
                  iconData: Icons.public,
                  iconBgColor: AppColors.success.withValues(alpha: 0.12),
                  iconColor: AppColors.success,
                  title: 'الرحلات المنشورة',
                  value: publishedTrips.toString(),
                  valueColor: AppColors.success,
                ),
                const Divider(height: 1, color: AppColors.divider),
                _buildTripRow(
                  iconData: Icons.description_outlined,
                  iconBgColor: AppColors.secondary.withValues(alpha: 0.15),
                  iconColor: AppColors.secondary,
                  title: 'المسودات',
                  value: draftTrips.toString(),
                  valueColor: AppColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTripRow({
    required IconData iconData,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.p12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          Row(
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSizes.p12.horizontalSpace,
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBgColor,
                ),
                child: Icon(iconData, color: iconColor, size: 18.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
