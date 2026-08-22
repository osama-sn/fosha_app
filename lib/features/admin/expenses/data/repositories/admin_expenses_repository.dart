import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import '../datasources/admin_expenses_remote_data_source.dart';
import '../models/expense_model.dart';

class AdminExpensesRepository {
  final AdminExpensesRemoteDataSource _dataSource;

  AdminExpensesRepository(this._dataSource);

  Future<Either<Failure, List<ExpenseModel>>> getExpenses({
    String? tripId,
    String? category,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final expenses = await _dataSource.getExpenses(
        tripId: tripId,
        category: category,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(expenses);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, List<ExpenseCategorySummaryModel>>> getExpensesSummary() async {
    try {
      final summary = await _dataSource.getExpensesSummary();
      return Right(summary);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, ExpenseModel>> addExpense({
    required String title,
    required double amount,
    required String category,
    String? tripId,
    String? expenseDate,
    String? notes,
    dynamic receiptImageFile,
  }) async {
    try {
      final expense = await _dataSource.addExpense(
        title: title,
        amount: amount,
        category: category,
        tripId: tripId,
        expenseDate: expenseDate,
        notes: notes,
        receiptImageFile: receiptImageFile,
      );
      return Right(expense);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, ExpenseModel>> updateExpense({
    required String expenseId,
    required String title,
    required double amount,
    required String category,
    String? tripId,
    String? expenseDate,
    String? notes,
    dynamic receiptImageFile,
  }) async {
    try {
      final expense = await _dataSource.updateExpense(
        expenseId: expenseId,
        title: title,
        amount: amount,
        category: category,
        tripId: tripId,
        expenseDate: expenseDate,
        notes: notes,
        receiptImageFile: receiptImageFile,
      );
      return Right(expense);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, void>> deleteExpense(String expenseId) async {
    try {
      await _dataSource.deleteExpense(expenseId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
