import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/expenses/data/constants/admin_expenses_constants.dart';
import 'package:fosha_app/features/admin/expenses/presentation/cubit/admin_expenses_cubit.dart';
import 'package:fosha_app/features/admin/expenses/presentation/widgets/add_expense_bottom_sheet.dart';
import 'package:fosha_app/features/admin/expenses/presentation/widgets/admin_expense_card.dart';
import 'package:fosha_app/features/admin/expenses/presentation/widgets/admin_expenses_category_filter.dart';
import 'package:fosha_app/features/admin/expenses/presentation/widgets/admin_expenses_delete_dialog.dart';
import 'package:fosha_app/features/admin/expenses/presentation/widgets/admin_expenses_empty_view.dart';
import 'package:fosha_app/features/admin/expenses/presentation/widgets/admin_expenses_header_card.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/admin/trips/data/repositories/admin_trips_repository.dart';

class AdminExpensesPage extends StatefulWidget {
  const AdminExpensesPage({super.key});

  @override
  State<AdminExpensesPage> createState() => _AdminExpensesPageState();
}

class _AdminExpensesPageState extends State<AdminExpensesPage> {
  String _selectedCategory = AdminExpensesConstants.categoryAll;
  final String _selectedTripId = 'all';
  List<TripModel> _trips = [];

  @override
  void initState() {
    super.initState();
    _loadTrips();
    context.read<AdminExpensesCubit>().fetchExpenses();
  }

  Future<void> _loadTrips() async {
    try {
      final repo = getIt<AdminTripsRepository>();
      final result = await repo.getTrips(page: 1, limit: 50);
      result.fold(
        (_) {},
        (paginatedTrips) {
          if (mounted) {
            setState(() {
              _trips = paginatedTrips.trips;
            });
          }
        },
      );
    } catch (_) {}
  }

  void _openAddExpenseSheet(BuildContext context) {
    final cubit = context.read<AdminExpensesCubit>();
    AddExpenseBottomSheet.show(
      context,
      trips: _trips,
      onAddExpense: ({
        required String title,
        required double amount,
        required String category,
        String? tripId,
        String? notes,
        String? receiptImageFile,
      }) {
        cubit.addExpense(
          title: title,
          amount: amount,
          category: category,
          tripId: tripId,
          notes: notes,
          receiptImageFile: receiptImageFile,
        );
      },
    );
  }

  void _confirmDeleteExpense(BuildContext context, String expenseId) {
    final cubit = context.read<AdminExpensesCubit>();
    AdminExpensesDeleteDialog.show(
      context,
      onConfirmDelete: () {
        cubit.deleteExpense(
          expenseId,
          category: _selectedCategory,
          tripId: _selectedTripId,
        );
      },
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
          AppStrings.adminExpensesTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddExpenseSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          AppStrings.adminAddExpense,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: BlocConsumer<AdminExpensesCubit, AdminExpensesState>(
        listener: (context, state) {
          if (state is AdminExpenseActionSuccess) {
            AppSnackbar.showSuccess(context: context, message: state.message);
          } else if (state is AdminExpensesError) {
            AppSnackbar.showError(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is AdminExpensesLoading) {
            return const Center(child: AppLoading());
          }

          if (state is AdminExpensesError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          if (state is AdminExpensesLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<AdminExpensesCubit>().fetchExpenses(
                      category: _selectedCategory,
                      tripId: _selectedTripId,
                    );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminExpensesHeaderCard(
                      totalAmount: state.totalAmount,
                      count: state.expenses.length,
                    ),
                    SizedBox(height: 16.h),
                    AdminExpensesCategoryFilter(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() => _selectedCategory = category);
                        context.read<AdminExpensesCubit>().fetchExpenses(
                              category: category,
                              tripId: _selectedTripId,
                            );
                      },
                    ),
                    SizedBox(height: 16.h),
                    if (state.expenses.isEmpty)
                      const AdminExpensesEmptyView()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.expenses.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final expense = state.expenses[index];
                          return AdminExpenseCard(
                            expense: expense,
                            onDelete: () =>
                                _confirmDeleteExpense(context, expense.id),
                          );
                        },
                      ),
                    SizedBox(height: 80.h),
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
