import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import '../models/company_review_model.dart';

abstract class AdminReviewsRemoteDataSource {
  Future<CompanyReviewsResponseModel> getCompanyReviews(String companyId);
  Future<List<CompanyReviewModel>> getTripReviews(String tripId);
}

class AdminReviewsRemoteDataSourceImpl implements AdminReviewsRemoteDataSource {
  final DioClient _dioClient;

  AdminReviewsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<CompanyReviewsResponseModel> getCompanyReviews(String companyId) async {
    String targetId = companyId;

    if (targetId.isEmpty || targetId == 'me') {
      try {
        final statsRes = await _dioClient.dio.get(ApiEndpoints.adminCompanyStats);
        final statsData = statsRes.data;
        if (statsData is Map<String, dynamic> && statsData['data'] != null) {
          final comp = statsData['data']['company'];
          if (comp is Map<String, dynamic>) {
            targetId = comp['_id']?.toString() ?? comp['id']?.toString() ?? '';
          }
        }
      } catch (_) {}
    }

    final response = await _dioClient.dio.get(
      ApiEndpoints.companyReviews(targetId),
    );

    return CompanyReviewsResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<List<CompanyReviewModel>> getTripReviews(String tripId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.tripReviews(tripId),
    );

    final rawData = response.data;
    List listData = [];
    if (rawData is Map<String, dynamic>) {
      final dataObj = rawData['data'];
      if (dataObj is List) {
        listData = dataObj;
      } else if (dataObj is Map<String, dynamic>) {
        if (dataObj['reviews'] is List) {
          listData = dataObj['reviews'] as List;
        }
      } else if (rawData['reviews'] is List) {
        listData = rawData['reviews'] as List;
      }
    } else if (rawData is List) {
      listData = rawData;
    }

    return listData
        .map((e) => CompanyReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
