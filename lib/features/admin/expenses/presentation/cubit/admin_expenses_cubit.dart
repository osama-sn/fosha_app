import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/features/admin/expenses/data/repositories/admin_expenses_repository.dart';
import 'admin_expenses_state.dart';
export 'admin_expenses_state.dart';

class AdminExpensesCubit extends Cubit<AdminExpensesState> {
  final AdminExpensesRepository _repository;

  AdminExpensesCubit(this._repository) : super(AdminExpensesInitial());

  Future<void> fetchExpenses({
    String? tripId,
    String? category,
    String? startDate,
    String? endDate,
  }) async {
    emit(AdminExpensesLoading());

    final expensesResult = await _repository.getExpenses(
      tripId: tripId,
      category: category,
      startDate: startDate,
      endDate: endDate,
    );

    await expensesResult.fold(
      (failure) async => emit(AdminExpensesError(failure.message)),
      (expenses) async {
        final summaryResult = await _repository.getExpensesSummary();

        summaryResult.fold(
          (failure) => emit(AdminExpensesLoaded(
            expenses: expenses,
            summary: const [],
            totalAmount: expenses.fold(0.0, (sum, item) => sum + item.amount),
          )),
          (summary) {
            final total = expenses.fold(0.0, (sum, item) => sum + item.amount);
            emit(AdminExpensesLoaded(
              expenses: expenses,
              summary: summary,
              totalAmount: total,
            ));
          },
        );
      },
    );
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    String? tripId,
    String? expenseDate,
    String? notes,
    dynamic receiptImageFile,
  }) async {
    final result = await _repository.addExpense(
      title: title,
      amount: amount,
      category: category,
      tripId: tripId,
      expenseDate: expenseDate,
      notes: notes,
      receiptImageFile: receiptImageFile,
    );

    await result.fold(
      (failure) async => emit(AdminExpensesError(failure.message)),
      (_) async {
        emit(AdminExpenseActionSuccess(AppStrings.adminExpenseAddSuccess));
        await fetchExpenses(tripId: tripId, category: category);
      },
    );
  }

  Future<void> deleteExpense(
    String expenseId, {
    String? tripId,
    String? category,
  }) async {
    final result = await _repository.deleteExpense(expenseId);

    await result.fold(
      (failure) async => emit(AdminExpensesError(failure.message)),
      (_) async {
        emit(AdminExpenseActionSuccess(AppStrings.adminExpenseDeleteSuccess));
        await fetchExpenses(tripId: tripId, category: category);
      },
    );
  }
}
