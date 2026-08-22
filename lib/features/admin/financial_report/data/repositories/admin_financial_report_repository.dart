import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import '../datasources/admin_financial_report_remote_data_source.dart';
import '../models/financial_report_model.dart';

class AdminFinancialReportRepository {
  final AdminFinancialReportRemoteDataSource _dataSource;

  AdminFinancialReportRepository(this._dataSource);

  Future<Either<Failure, FinancialReportModel>> getFinancialReport({
    String? startDate,
    String? endDate,
    int? month,
    int? year,
  }) async {
    try {
      final report = await _dataSource.getFinancialReport(
        startDate: startDate,
        endDate: endDate,
        month: month,
        year: year,
      );
      return Right(report);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
