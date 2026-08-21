import '../datasources/admin_expenses_remote_data_source.dart';
import '../models/expense_model.dart';

class AdminExpensesRepository {
  final AdminExpensesRemoteDataSource _dataSource;

  AdminExpensesRepository(this._dataSource);

  Future<List<ExpenseModel>> getExpenses({
    String? tripId,
    String? category,
    String? startDate,
    String? endDate,
  }) {
    return _dataSource.getExpenses(
      tripId: tripId,
      category: category,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<ExpenseCategorySummaryModel>> getExpensesSummary() {
    return _dataSource.getExpensesSummary();
  }

  Future<ExpenseModel> addExpense({
    required String title,
    required double amount,
    required String category,
    String? tripId,
    String? expenseDate,
    String? notes,
    dynamic receiptImageFile,
  }) {
    return _dataSource.addExpense(
      title: title,
      amount: amount,
      category: category,
      tripId: tripId,
      expenseDate: expenseDate,
      notes: notes,
      receiptImageFile: receiptImageFile,
    );
  }

  Future<ExpenseModel> updateExpense({
    required String expenseId,
    required String title,
    required double amount,
    required String category,
    String? tripId,
    String? expenseDate,
    String? notes,
    dynamic receiptImageFile,
  }) {
    return _dataSource.updateExpense(
      expenseId: expenseId,
      title: title,
      amount: amount,
      category: category,
      tripId: tripId,
      expenseDate: expenseDate,
      notes: notes,
      receiptImageFile: receiptImageFile,
    );
  }

  Future<void> deleteExpense(String expenseId) {
    return _dataSource.deleteExpense(expenseId);
  }
}
