import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import '../models/financial_report_model.dart';

abstract class AdminFinancialReportRemoteDataSource {
  Future<FinancialReportModel> getFinancialReport({
    String? startDate,
    String? endDate,
    int? month,
    int? year,
  });
}

class AdminFinancialReportRemoteDataSourceImpl
    implements AdminFinancialReportRemoteDataSource {
  final DioClient _dioClient;

  AdminFinancialReportRemoteDataSourceImpl(this._dioClient);

  @override
  Future<FinancialReportModel> getFinancialReport({
    String? startDate,
    String? endDate,
    int? month,
    int? year,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null && startDate.isNotEmpty) {
      queryParams['startDate'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      queryParams['endDate'] = endDate;
    }
    if (month != null) {
      queryParams['month'] = month;
    }
    if (year != null) {
      queryParams['year'] = year;
    }

    final response = await _dioClient.dio.get(
      ApiEndpoints.adminCompanyStats,
      queryParameters: queryParams,
    );

    return FinancialReportModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
