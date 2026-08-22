import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/financial_report/presentation/cubit/admin_financial_report_cubit.dart';
import 'package:fosha_app/features/admin/financial_report/presentation/widgets/admin_financial_period_filter.dart';
import 'package:fosha_app/features/admin/financial_report/presentation/widgets/admin_financial_stat_card.dart';
import 'package:fosha_app/features/admin/financial_report/presentation/widgets/admin_net_profit_card.dart';
import 'package:fosha_app/features/admin/financial_report/presentation/widgets/admin_trip_financial_card.dart';

class AdminFinancialReportPage extends StatefulWidget {
  const AdminFinancialReportPage({super.key});

  @override
  State<AdminFinancialReportPage> createState() =>
      _AdminFinancialReportPageState();
}

class _AdminFinancialReportPageState extends State<AdminFinancialReportPage> {
  int? _selectedMonth;
  int? _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    context.read<AdminFinancialReportCubit>().fetchFinancialReport(
          year: _selectedYear,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Text(
          AppStrings.adminFinancialReportTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AdminFinancialReportCubit, AdminFinancialReportState>(
        builder: (context, state) {
          if (state is AdminFinancialReportLoading) {
            return const Center(child: AppLoading());
          }

          if (state is AdminFinancialReportError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          if (state is AdminFinancialReportLoaded) {
            final fin = state.report.financials;
            return RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<AdminFinancialReportCubit>()
                    .fetchFinancialReport(
                      month: _selectedMonth,
                      year: _selectedYear,
                    );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminFinancialPeriodFilter(
                      selectedMonth: _selectedMonth,
                      selectedYear: _selectedYear,
                      onMonthChanged: (val) {
                        setState(() => _selectedMonth = val);
                        context
                            .read<AdminFinancialReportCubit>()
                            .fetchFinancialReport(
                              month: val,
                              year: _selectedYear,
                            );
                      },
                      onYearChanged: (val) {
                        setState(() => _selectedYear = val);
                        context
                            .read<AdminFinancialReportCubit>()
                            .fetchFinancialReport(
                              month: _selectedMonth,
                              year: val,
                            );
                      },
                    ),
                    SizedBox(height: 16.h),

                    AdminNetProfitCard(netProfit: fin.netProfit),
                    SizedBox(height: 16.h),

                    // Financial Stats Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 1.6,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        AdminFinancialStatCard(
                          title: AppStrings.adminTotalGrossRevenue,
                          value:
                              '${fin.totalGrossRevenue.toStringAsFixed(0)} ${AppStrings.currencyEGP}',
                          icon: Icons.trending_up,
                          color: Colors.green,
                        ),
                        AdminFinancialStatCard(
                          title: AppStrings.adminTotalExpenses,
                          value:
                              '${fin.totalExpenses.toStringAsFixed(0)} ${AppStrings.currencyEGP}',
                          icon: Icons.trending_down,
                          color: Colors.red,
                        ),
                        AdminFinancialStatCard(
                          title: AppStrings.adminPlatformCommission,
                          value:
                              '${fin.totalAdminCommissionPaid.toStringAsFixed(0)} ${AppStrings.currencyEGP}',
                          icon: Icons.account_balance,
                          color: Colors.orange,
                        ),
                        AdminFinancialStatCard(
                          title: AppStrings.adminTotalBookingsLabel,
                          value:
                              '${fin.totalBookings} ${AppStrings.adminBookingUnit} (${fin.totalSeats} ${AppStrings.adminPersonUnit})',
                          icon: Icons.confirmation_number_outlined,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    if (state.report.perTripPerformance.isNotEmpty) ...[
                      Text(
                        AppStrings.adminTripFinancialPerformance,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.report.perTripPerformance.length,
                        separatorBuilder: (_, _) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final trip = state.report.perTripPerformance[index];
                          return AdminTripFinancialCard(trip: trip);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
