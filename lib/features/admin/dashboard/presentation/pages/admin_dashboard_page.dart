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
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_quick_promotions_section.dart';
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
              companyName: stats.company?.name ?? '',
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
                          const AdminQuickPromotionsSection(),
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
        title: Text(AppStrings.logoutConfirmTitle),
        content: Text(AppStrings.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              AppStrings.profileLogout,
              style: const TextStyle(color: AppColors.error),
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
          message: AppStrings.logoutSuccessMessage,
        );
        context.go(RouteNames.login);
      }
    }
  }
}
