import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/financial_report/presentation/cubit/admin_financial_report_cubit.dart';

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
          'التقارير المالية والأرباح',
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
                    // Period Filter Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int?>(
                            value: _selectedMonth,
                            decoration: InputDecoration(
                              labelText: 'الشهر',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 8.h),
                              border: const OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem(
                                  value: null, child: Text('جميع الشهور')),
                              ...List.generate(
                                12,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text('شهر ${i + 1}'),
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              setState(() => _selectedMonth = val);
                              context
                                  .read<AdminFinancialReportCubit>()
                                  .fetchFinancialReport(
                                    month: val,
                                    year: _selectedYear,
                                  );
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: DropdownButtonFormField<int?>(
                            value: _selectedYear,
                            decoration: InputDecoration(
                              labelText: 'السنة',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 8.h),
                              border: const OutlineInputBorder(),
                            ),
                            items: [2024, 2025, 2026, 2027].map((y) {
                              return DropdownMenuItem(
                                value: y,
                                child: Text('$y'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => _selectedYear = val);
                              context
                                  .read<AdminFinancialReportCubit>()
                                  .fetchFinancialReport(
                                    month: _selectedMonth,
                                    year: val,
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Net Profit Card (Hero Card)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryDark, AppColors.primary],
                        ),
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '💵 صافي الربح الفعلي',
                                style: AppTextStyles.titleMedium
                                    .copyWith(color: Colors.white70),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: const Text(
                                  'Net Profit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '${fin.netProfit.toStringAsFixed(0)} ج.م',
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'المعادلة: (المبيعات - المصروفات - عمولة المنصة)',
                            style: AppTextStyles.labelSmall
                                .copyWith(color: Colors.white70, fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),
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
                        _buildStatCard(
                          title: 'إجمالي المبيعات (GMV)',
                          value: '${fin.totalGrossRevenue.toStringAsFixed(0)} ج.م',
                          icon: Icons.trending_up,
                          color: Colors.green,
                        ),
                        _buildStatCard(
                          title: 'إجمالي المصروفات',
                          value: '${fin.totalExpenses.toStringAsFixed(0)} ج.م',
                          icon: Icons.trending_down,
                          color: Colors.red,
                        ),
                        _buildStatCard(
                          title: 'عمولة المنصة',
                          value:
                              '${fin.totalAdminCommissionPaid.toStringAsFixed(0)} ج.م',
                          icon: Icons.account_balance,
                          color: Colors.orange,
                        ),
                        _buildStatCard(
                          title: 'إجمالي الحجوزات',
                          value: '${fin.totalBookings} حجز (${fin.totalSeats} فرد)',
                          icon: Icons.confirmation_number_outlined,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Per Trip Performance Section
                    if (state.report.perTripPerformance.isNotEmpty) ...[
                      Text(
                        'أداء الرحلات المالي',
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
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final trip = state.report.perTripPerformance[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(14.r),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        AppColors.primary.withValues(alpha: 0.1),
                                    child: const Icon(Icons.explore,
                                        color: AppColors.primary),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trip.title,
                                          style: AppTextStyles.bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          '${trip.totalBookings} حجوزات - ${trip.totalSeats} مقعد',
                                          style: AppTextStyles.bodySmall.copyWith(
                                              color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${trip.totalRevenue.toStringAsFixed(0)} ج.م',
                                        style: AppTextStyles.titleSmall.copyWith(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'عمولة: ${trip.totalCommission.toStringAsFixed(0)} ج.م',
                                        style: AppTextStyles.labelSmall.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: 10.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20.r),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
