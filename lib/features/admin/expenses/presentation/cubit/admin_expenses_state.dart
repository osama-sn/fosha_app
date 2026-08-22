import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/expenses/data/models/expense_model.dart';

abstract class AdminExpensesState extends Equatable {
  const AdminExpensesState();

  @override
  List<Object?> get props => [];
}

class AdminExpensesInitial extends AdminExpensesState {}

class AdminExpensesLoading extends AdminExpensesState {}

class AdminExpensesLoaded extends AdminExpensesState {
  final List<ExpenseModel> expenses;
  final List<ExpenseCategorySummaryModel> summary;
  final double totalAmount;

  const AdminExpensesLoaded({
    required this.expenses,
    required this.summary,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [expenses, summary, totalAmount];
}

class AdminExpensesError extends AdminExpensesState {
  final String message;

  const AdminExpensesError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminExpenseActionSuccess extends AdminExpensesState {
  final String message;

  const AdminExpenseActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
