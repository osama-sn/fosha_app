import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/admin/customers/data/models/company_customer_model.dart';
import 'package:fosha_app/features/admin/customers/data/repositories/admin_customers_repository.dart';

abstract class AdminCustomersState {}

class AdminCustomersInitial extends AdminCustomersState {}

class AdminCustomersLoading extends AdminCustomersState {}

class AdminCustomersLoaded extends AdminCustomersState {
  final List<CompanyCustomerModel> customers;
  AdminCustomersLoaded(this.customers);
}

class AdminCustomersError extends AdminCustomersState {
  final String message;
  AdminCustomersError(this.message);
}

class AdminCustomersCubit extends Cubit<AdminCustomersState> {
  final AdminCustomersRepository _repository;

  AdminCustomersCubit(this._repository) : super(AdminCustomersInitial());

  Future<void> fetchCustomers({String? search}) async {
    emit(AdminCustomersLoading());
    final result = await _repository.getCompanyCustomers(search: search);

    result.fold(
      (failure) => emit(AdminCustomersError(failure.message)),
      (customers) => emit(AdminCustomersLoaded(customers)),
    );
  }
}
