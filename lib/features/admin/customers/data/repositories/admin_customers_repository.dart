import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import '../datasources/admin_customers_remote_data_source.dart';
import '../models/company_customer_model.dart';

class AdminCustomersRepository {
  final AdminCustomersRemoteDataSource _dataSource;

  AdminCustomersRepository(this._dataSource);

  Future<Either<Failure, List<CompanyCustomerModel>>> getCompanyCustomers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final response = await _dataSource.getCompanyCustomers(
        page: page,
        limit: limit,
        search: search,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
