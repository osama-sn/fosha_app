import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/dashboard/data/models/stats_model.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/cubit/admin_cubit.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/cubit/admin_states.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_bookings_grid.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_bottom_nav_bar.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_dashboard_header.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_financials_section.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_net_profit_card.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_subscription_card.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_trips_card.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_welcome_section.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_cubit.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminCubit>(
      create: (context) => getIt<AdminCubit>()..fetchDashboardStats(),
      child: BlocBuilder<AdminCubit, AdminStates>(
        builder: (context, state) {
          final stats = state is AdminDashboardSuccess
              ? state.stats
              : const AdminDashboardStatsModel(
                  trips: TripsStatsModel(
                    totalTrips: 0,
                    publishedTrips: 0,
                    draftTrips: 0,
                  ),
                  bookings: BookingsStatsModel(
                    totalBookings: 0,
                    pendingBookings: 0,
                    approvedBookings: 0,
                    rejectedBookings: 0,
                  ),
                  financials: FinancialsStatsModel(
                    totalGrossRevenue: 0,
                    totalAdminCommissionPaid: 0,
                    totalCompanyNetRevenue: 0,
                  ),
                );

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AdminDashboardHeader(
              companyName: stats.company?.name ?? 'شركة فسحني شكراً',
              onLogout: () => _showLogoutDialog(context),
            ),
            body: SafeArea(
              child: Builder(
                builder: (context) {
                  if (state is AdminDashboardLoading) return const AppLoading();
                  if (state is AdminDashboardFailure) {
                    return _buildError(state, context);
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<AdminCubit>().fetchDashboardStats(),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.p16,
                        vertical: AppSizes.p16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const AdminWelcomeSection(),
                          AppSizes.p20.verticalSpace,
                          AdminNetProfitCard(
                            netRevenue: stats.financials.totalCompanyNetRevenue,
                          ),
                          AppSizes.p24.verticalSpace,
                          AdminFinancialsSection(
                            grossRevenue: stats.financials.totalGrossRevenue,
                            adminCommissionPaid:
                                stats.financials.totalAdminCommissionPaid,
                          ),
                          AppSizes.p24.verticalSpace,
                          AdminBookingsGrid(
                            totalBookings: stats.bookings.totalBookings,
                            approvedBookings: stats.bookings.approvedBookings,
                            pendingBookings: stats.bookings.pendingBookings,
                            rejectedBookings: stats.bookings.rejectedBookings,
                          ),
                          AppSizes.p24.verticalSpace,
                          AdminTripsCard(
                            totalTrips: stats.trips.totalTrips,
                            publishedTrips: stats.trips.publishedTrips,
                            draftTrips: stats.trips.draftTrips,
                          ),
                          AppSizes.p24.verticalSpace,
                          _buildQuickPromotionsSection(context),
                          AppSizes.p24.verticalSpace,
                          AdminSubscriptionCard(
                            monthlySubscriptionFee:
                                (stats.company?.monthlySubscriptionFee ?? 500)
                                    .toDouble(),
                            commissionValue:
                                (stats.company?.commissionValue ?? 10)
                                    .toDouble(),
                          ),
                          AppSizes.p20.verticalSpace,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            bottomNavigationBar: const AdminBottomNavBar(selectedIndex: 0),
          );
        },
      ),
    );
  }

  Widget _buildError(AdminDashboardFailure state, BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 48.r),
            AppSizes.p16.verticalSpace,
            Text(
              AppStrings.errorOccurred,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSizes.p8.verticalSpace,
            Text(
              state.error,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSizes.p24.verticalSpace,
            AppButton(
              text: AppStrings.retry,
              onPressed: () => context.read<AdminCubit>().fetchDashboardStats(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت تأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authCubit = getIt<AuthCubit>();
      await authCubit.logout();
      if (context.mounted) {
        AppSnackbar.showSuccess(
          context: context,
          message: 'تم تسجيل الخروج بنجاح',
        );
        context.go(RouteNames.login);
      }
    }
  }

  Widget _buildQuickPromotionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التسويق والعروض',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppSizes.p12.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                title: 'العروض الترويجية',
                subtitle: 'إدارة وتخصيص الخصومات',
                icon: Icons.local_offer_outlined,
                color: AppColors.secondary,
                onTap: () => context.push(RouteNames.companyOffers),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionCard(
                context,
                title: 'كوبونات الخصم',
                subtitle: 'أكواد الخصم الخاصة بالشركة',
                icon: Icons.confirmation_number_outlined,
                color: AppColors.primaryDark,
                onTap: () => context.push(RouteNames.companyCoupons),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 24.r),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

