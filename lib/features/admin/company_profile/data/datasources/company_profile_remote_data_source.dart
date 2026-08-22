import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_payment_account_model.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_review_model.dart';

abstract class CompanyProfileRemoteDataSource {
  Future<CompanyProfileModel> getCompanyProfile(String companyId);
  Future<CompanyProfileModel> updateCompanyProfile(
    String companyId,
    Map<String, dynamic> data,
  );
  Future<List<CompanyReviewModel>> getCompanyReviews(String companyId);

  // Company Payment Accounts
  Future<List<CompanyPaymentAccountModel>> getPaymentAccounts(String companyId);
  Future<CompanyPaymentAccountModel> addPaymentAccount(
    String companyId,
    Map<String, dynamic> data,
  );
  Future<CompanyPaymentAccountModel> updatePaymentAccount(
    String companyId,
    String accountId,
    Map<String, dynamic> data,
  );
  Future<CompanyPaymentAccountModel> togglePaymentAccount(
    String companyId,
    String accountId,
  );
  Future<void> deletePaymentAccount(String companyId, String accountId);
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

  @override
  Future<List<CompanyPaymentAccountModel>> getPaymentAccounts(
    String companyId,
  ) async {
    final response = await _dioClient.dio.get(
      '${ApiEndpoints.companies}/$companyId/payment-accounts',
    );
    final rawList = _extractAccountsList(response.data);
    return rawList
        .map((e) => CompanyPaymentAccountModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CompanyPaymentAccountModel> addPaymentAccount(
    String companyId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dioClient.dio.post(
      '${ApiEndpoints.companies}/$companyId/payment-accounts',
      data: data,
    );
    return CompanyPaymentAccountModel.fromJson(
      _extractAccountMap(response.data),
    );
  }

  @override
  Future<CompanyPaymentAccountModel> updatePaymentAccount(
    String companyId,
    String accountId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dioClient.dio.patch(
      '${ApiEndpoints.companies}/$companyId/payment-accounts/$accountId',
      data: data,
    );
    return CompanyPaymentAccountModel.fromJson(
      _extractAccountMap(response.data),
    );
  }

  @override
  Future<CompanyPaymentAccountModel> togglePaymentAccount(
    String companyId,
    String accountId,
  ) async {
    final response = await _dioClient.dio.patch(
      '${ApiEndpoints.companies}/$companyId/payment-accounts/$accountId/toggle',
    );
    return CompanyPaymentAccountModel.fromJson(
      _extractAccountMap(response.data),
    );
  }

  @override
  Future<void> deletePaymentAccount(
    String companyId,
    String accountId,
  ) async {
    await _dioClient.dio.delete(
      '${ApiEndpoints.companies}/$companyId/payment-accounts/$accountId',
    );
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

  List<dynamic> _extractAccountsList(dynamic res) {
    final data = res?['data'];
    if (data is List) return data;
    if (data is Map && data['accounts'] is List) return data['accounts'] as List;
    if (data is Map && data['paymentAccounts'] is List) {
      return data['paymentAccounts'] as List;
    }
    return res is List ? res : const [];
  }

  Map<String, dynamic> _extractAccountMap(dynamic res) {
    final data = res?['data'];
    if (data is Map<String, dynamic>) {
      final acc = data['account'] ?? data['paymentAccount'] ?? data;
      if (acc is Map<String, dynamic>) return acc;
    }
    return (res is Map<String, dynamic> ? res : {}) as Map<String, dynamic>;
  }
}
