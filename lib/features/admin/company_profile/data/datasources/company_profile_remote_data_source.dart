import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';

abstract class CompanyProfileRemoteDataSource {
  Future<CompanyProfileModel> getCompanyProfile(String companyId);
  Future<CompanyProfileModel> updateCompanyProfile(
    String companyId,
    Map<String, dynamic> data,
  );
}

class CompanyProfileRemoteDataSourceImpl
    implements CompanyProfileRemoteDataSource {
  final DioClient _dioClient;

  CompanyProfileRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<CompanyProfileModel> getCompanyProfile(String companyId) async {
    final response = await _dioClient.dio.get(
      '${ApiEndpoints.companies}/$companyId',
    );
    final responseData = response.data;
    Map<String, dynamic> companyJson;

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] != null && responseData['data'] is Map) {
        final dataMap = responseData['data'] as Map<String, dynamic>;
        companyJson = dataMap['company'] is Map
            ? dataMap['company'] as Map<String, dynamic>
            : dataMap;
      } else {
        companyJson = responseData;
      }
    } else {
      throw Exception('نطاق الاستجابة غير صحيح');
    }

    return CompanyProfileModel.fromJson(companyJson);
  }

  @override
  Future<CompanyProfileModel> updateCompanyProfile(
    String companyId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dioClient.dio.put(
      '${ApiEndpoints.companies}/$companyId',
      data: data,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    final responseData = response.data;
    Map<String, dynamic> companyJson;

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] != null && responseData['data'] is Map) {
        final dataMap = responseData['data'] as Map<String, dynamic>;
        companyJson = dataMap['company'] is Map
            ? dataMap['company'] as Map<String, dynamic>
            : dataMap;
      } else {
        companyJson = responseData;
      }
    } else {
      throw Exception('فشل تحديث ملف الشركة');
    }

    return CompanyProfileModel.fromJson(companyJson);
  }
}
