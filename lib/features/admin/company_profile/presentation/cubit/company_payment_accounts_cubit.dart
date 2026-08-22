import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_payment_account_model.dart';
import 'package:fosha_app/features/admin/company_profile/data/repositories/company_profile_repository.dart';
import 'company_payment_accounts_state.dart';

export 'company_payment_accounts_state.dart';

class CompanyPaymentAccountsCubit extends Cubit<CompanyPaymentAccountsState> {
  final CompanyProfileRepository repository;

  CompanyPaymentAccountsCubit({required this.repository})
      : super(CompanyPaymentAccountsInitial());

  Future<void> loadPaymentAccounts(String companyId) async {
    emit(CompanyPaymentAccountsLoading());
    final result = await repository.getPaymentAccounts(companyId);
    result.fold(
      (failure) => emit(CompanyPaymentAccountsError(failure.message)),
      (accounts) => emit(CompanyPaymentAccountsLoaded(accounts: accounts)),
    );
  }

  Future<void> addPaymentAccount(
    String companyId,
    CompanyPaymentAccountModel account,
  ) async {
    final currentState = state;
    List<CompanyPaymentAccountModel> currentList = [];
    if (currentState is CompanyPaymentAccountsLoaded) {
      currentList = List.from(currentState.accounts);
    }

    emit(CompanyPaymentAccountsLoading());
    final result = await repository.addPaymentAccount(companyId, account);
    result.fold(
      (failure) => emit(CompanyPaymentAccountsError(failure.message)),
      (newAccount) {
        currentList.insert(0, newAccount);
        emit(CompanyPaymentAccountsLoaded(
          accounts: currentList,
          successMessage: 'تم إضافة حساب الدفع بنجاح',
        ));
      },
    );
  }

  Future<void> toggleAccountActive(
    String companyId,
    String accountId,
  ) async {
    final currentState = state;
    if (currentState is! CompanyPaymentAccountsLoaded) return;

    final updatedList = currentState.accounts.map((acc) {
      if (acc.id == accountId) {
        return acc.copyWith(isActive: !acc.isActive);
      }
      return acc;
    }).toList();

    emit(CompanyPaymentAccountsLoaded(accounts: updatedList));

    final result = await repository.togglePaymentAccount(companyId, accountId);
    result.fold(
      (failure) {
        // Revert on error
        loadPaymentAccounts(companyId);
      },
      (updatedAccount) {
        final finalList = updatedList.map((acc) {
          if (acc.id == accountId) return updatedAccount;
          return acc;
        }).toList();
        emit(CompanyPaymentAccountsLoaded(
          accounts: finalList,
          successMessage: 'تم تغيير حالة تفعيل الحساب',
        ));
      },
    );
  }

  Future<void> deletePaymentAccount(
    String companyId,
    String accountId,
  ) async {
    final currentState = state;
    if (currentState is! CompanyPaymentAccountsLoaded) return;

    final currentList = List<CompanyPaymentAccountModel>.from(currentState.accounts);
    currentList.removeWhere((acc) => acc.id == accountId);

    emit(CompanyPaymentAccountsLoading());
    final result = await repository.deletePaymentAccount(companyId, accountId);
    result.fold(
      (failure) => emit(CompanyPaymentAccountsError(failure.message)),
      (_) => emit(CompanyPaymentAccountsLoaded(
        accounts: currentList,
        successMessage: 'تم حذف حساب الدفع بنجاح',
      )),
    );
  }
}
