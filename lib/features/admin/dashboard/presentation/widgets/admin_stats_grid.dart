import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/dashboard/data/models/stats_model.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_stat_card.dart';

class AdminStatsGrid extends StatelessWidget {
  final AdminDashboardStatsModel stats;
  const AdminStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (stats.totalGrossRevenue > 0) ...[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p12,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.r12),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.insights,
                      size: 18.sp,
                      color: AppColors.primary,
                    ),
                    AppSizes.p8.horizontalSpace,
                    Text(
                      'المبيعات: ${stats.totalGrossRevenue.toStringAsFixed(0)} ج.م',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'العمولة: ${stats.totalAdminCommissionPaid.toStringAsFixed(0)} ج.م',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          AppSizes.p12.verticalSpace,
        ],
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppSizes.p12,
          mainAxisSpacing: AppSizes.p12,
          childAspectRatio: 1.25,
          children: [
            AdminStatCard(
              title: 'صافي الأرباح',
              value: "${stats.totalCompanyNetRevenue.toStringAsFixed(0)} ج.م",
              icon: Icons.account_balance_wallet_outlined,
              color: Colors.green,
              onTap: () {},
            ),
            AdminStatCard(
              title: AppStrings.adminTotalTrips,
              value: stats.totalTrips.toString(),
              icon: Icons.card_travel,
              color: AppColors.primary,
              onTap: () => context.push(RouteNames.adminTrips),
            ),
            AdminStatCard(
              title: AppStrings.adminTotalBookings,
              value: stats.totalBookings.toString(),
              icon: Icons.confirmation_number_outlined,
              color: Colors.purple,
              onTap: () => context.push(RouteNames.adminBookings),
            ),
            AdminStatCard(
              title: AppStrings.adminPendingBookings,
              value: stats.pendingBookings.toString(),
              icon: Icons.hourglass_empty,
              color: Colors.orange,
              onTap: () => context.push(RouteNames.adminBookings),
            ),
          ],
        ),
      ],
    );
  }
}



