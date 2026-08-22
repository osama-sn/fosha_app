import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_payment_account_model.dart';

abstract class CompanyPaymentAccountsState extends Equatable {
  const CompanyPaymentAccountsState();

  @override
  List<Object?> get props => [];
}

class CompanyPaymentAccountsInitial extends CompanyPaymentAccountsState {}

class CompanyPaymentAccountsLoading extends CompanyPaymentAccountsState {}

class CompanyPaymentAccountsLoaded extends CompanyPaymentAccountsState {
  final List<CompanyPaymentAccountModel> accounts;
  final String? successMessage;

  const CompanyPaymentAccountsLoaded({
    required this.accounts,
    this.successMessage,
  });

  @override
  List<Object?> get props => [accounts, successMessage];
}

class CompanyPaymentAccountsError extends CompanyPaymentAccountsState {
  final String error;

  const CompanyPaymentAccountsError(this.error);

  @override
  List<Object?> get props => [error];
}
