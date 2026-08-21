import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/features/admin/expenses/data/models/expense_model.dart';
import 'package:fosha_app/features/admin/expenses/data/repositories/admin_expenses_repository.dart';

abstract class AdminExpensesState {}

class AdminExpensesInitial extends AdminExpensesState {}

class AdminExpensesLoading extends AdminExpensesState {}

class AdminExpensesLoaded extends AdminExpensesState {
  final List<ExpenseModel> expenses;
  final List<ExpenseCategorySummaryModel> summary;
  final double totalAmount;

  AdminExpensesLoaded({
    required this.expenses,
    required this.summary,
    required this.totalAmount,
  });
}

class AdminExpensesError extends AdminExpensesState {
  final String message;
  AdminExpensesError(this.message);
}

class AdminExpenseActionSuccess extends AdminExpensesState {
  final String message;
  AdminExpenseActionSuccess(this.message);
}

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
    try {
      final expenses = await _repository.getExpenses(
        tripId: tripId,
        category: category,
        startDate: startDate,
        endDate: endDate,
      );
      final summary = await _repository.getExpensesSummary();
      final total = expenses.fold(0.0, (sum, item) => sum + item.amount);

      emit(AdminExpensesLoaded(
        expenses: expenses,
        summary: summary,
        totalAmount: total,
      ));
    } catch (e) {
      emit(AdminExpensesError(ApiErrorHandler.handle(e)));
    }
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
    try {
      await _repository.addExpense(
        title: title,
        amount: amount,
        category: category,
        tripId: tripId,
        expenseDate: expenseDate,
        notes: notes,
        receiptImageFile: receiptImageFile,
      );
      emit(AdminExpenseActionSuccess('تمت إضافة المصروف بنجاح'));
      await fetchExpenses(tripId: tripId, category: category);
    } catch (e) {
      emit(AdminExpensesError(ApiErrorHandler.handle(e)));
    }
  }

  Future<void> deleteExpense(String expenseId, {String? tripId, String? category}) async {
    try {
      await _repository.deleteExpense(expenseId);
      emit(AdminExpenseActionSuccess('تم حذف المصروف بنجاح'));
      await fetchExpenses(tripId: tripId, category: category);
    } catch (e) {
      emit(AdminExpensesError(ApiErrorHandler.handle(e)));
    }
  }
}
