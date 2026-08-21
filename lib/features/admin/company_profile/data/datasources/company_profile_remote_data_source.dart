import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_review_model.dart';

abstract class CompanyProfileRemoteDataSource {
  Future<CompanyProfileModel> getCompanyProfile(String companyId);
  Future<CompanyProfileModel> updateCompanyProfile(
    String companyId,
    Map<String, dynamic> data,
  );
  Future<List<CompanyReviewModel>> getCompanyReviews(String companyId);
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
    return CompanyProfileModel.fromJson(_extractCompanyMap(response.data));
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
        headers: const {'Content-Type': 'application/json'},
      ),
    );
    return CompanyProfileModel.fromJson(_extractCompanyMap(response.data));
  }

  @override
  Future<List<CompanyReviewModel>> getCompanyReviews(String companyId) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.companies}/$companyId/reviews',
      );
      return _extractReviewsList(response.data);
    } catch (_) {
      return const [];
    }
  }

  Map<String, dynamic> _extractCompanyMap(dynamic res) {
    final data = res?['data'];
    return (data?['company'] ?? data ?? res ?? {}) as Map<String, dynamic>;
  }

  List<CompanyReviewModel> _extractReviewsList(dynamic res) {
    final data = res?['data'];
    final list = (data is Map ? data['reviews'] : data) as List? ?? [];
    return list
        .map((e) => CompanyReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
