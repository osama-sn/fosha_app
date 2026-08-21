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
    final response = await _dioClient.dio.get(
      ApiEndpoints.adminCompanyStats,
    );

    return FinancialReportModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
