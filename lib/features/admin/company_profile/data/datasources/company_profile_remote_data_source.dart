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
  Future<List<Map<String, dynamic>>> getCompanyReviews(String companyId);
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

  @override
  Future<List<Map<String, dynamic>>> getCompanyReviews(String companyId) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.companies}/$companyId/reviews',
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['data'] != null) {
        final data = responseData['data'];
        if (data is List) {
          return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        } else if (data is Map && data['reviews'] is List) {
          return (data['reviews'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
