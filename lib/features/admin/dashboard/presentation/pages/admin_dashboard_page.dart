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
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:fosha_app/features/admin/dashboard/data/models/stats_model.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/cubit/admin_cubit.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/cubit/admin_states.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_management_section.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_stats_grid.dart';
import 'package:fosha_app/features/admin/dashboard/presentation/widgets/admin_welcome_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminCubit>(
      create: (context) => getIt<AdminCubit>()..fetchDashboardStats(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            AppStrings.adminDashboardTitle,
            style: AppTextStyles.titleLarge,
          ),
          actions: [
            IconButton(
              tooltip: AppStrings.adminSwitchUserMode,
              icon: const Icon(Icons.swap_horiz, color: AppColors.primary),
              onPressed: () => context.go(RouteNames.home),
            ),
            IconButton(
              tooltip: AppStrings.profileLogout,
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () => _showLogoutDialog(context),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<AdminCubit, AdminStates>(
            builder: (context, state) {
              if (state is AdminDashboardLoading) return const AppLoading();
              if (state is AdminDashboardFailure) {
                return _buildError(state, context);
              }

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
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<AdminCubit>().fetchDashboardStats(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSizes.p20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AdminWelcomeCard(
                        companyInfo: stats.company,
                        companyName: stats.company?.name,
                      ),
                      AppSizes.p20.verticalSpace,
                      Text(
                        AppStrings.adminOverview,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p12.verticalSpace,
                      AdminStatsGrid(stats: stats),
                      AppSizes.p24.verticalSpace,
                      Text(
                        AppStrings.adminQuickActions,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p12.verticalSpace,
                      const AdminManagementSection(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Center _buildError(AdminDashboardFailure state, BuildContext context) {
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
}
