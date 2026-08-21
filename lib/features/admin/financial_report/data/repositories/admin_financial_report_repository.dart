import '../datasources/admin_financial_report_remote_data_source.dart';
import '../models/financial_report_model.dart';

class AdminFinancialReportRepository {
  final AdminFinancialReportRemoteDataSource _dataSource;

  AdminFinancialReportRepository(this._dataSource);

  Future<FinancialReportModel> getFinancialReport({
    String? startDate,
    String? endDate,
    int? month,
    int? year,
  }) {
    return _dataSource.getFinancialReport(
      startDate: startDate,
      endDate: endDate,
      month: month,
      year: year,
    );
  }
}
