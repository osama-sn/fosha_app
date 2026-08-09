import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/trips/data/models/paginated_trips_model.dart';

abstract class SearchRemoteDataSource {
  Future<PaginatedTripsModel> searchTrips({
    int page = 1,
    int limit = 10,
    String? search,
    String? origin,
    String? destination,
    String? category,
    String? governorate,
    String? companyId,
    bool myGovernorateOnly = false,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient dioClient;

  SearchRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<PaginatedTripsModel> searchTrips({
    int page = 1,
    int limit = 10,
    String? search,
    String? origin,
    String? destination,
    String? category,
    String? governorate,
    String? companyId,
    bool myGovernorateOnly = false,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'myGovernorateOnly': myGovernorateOnly,
      };

      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (origin != null && origin.trim().isNotEmpty) {
        queryParams['origin'] = origin.trim();
      }
      if (destination != null && destination.trim().isNotEmpty) {
        queryParams['destination'] = destination.trim();
      }
      if (category != null && category.trim().isNotEmpty && category != 'all') {
        queryParams['category'] = category.trim();
      }
      if (governorate != null && governorate.trim().isNotEmpty) {
        queryParams['governorate'] = governorate.trim();
      }
      if (companyId != null && companyId.trim().isNotEmpty) {
        queryParams['company'] = companyId.trim();
      }

      final response = await dioClient.dio.get(
        ApiEndpoints.trips,
        queryParameters: queryParams,
      );

      return PaginatedTripsModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message']?.toString() ??
          e.message ??
          'Search error';
      throw Exception(errorMsg);
    } catch (e) {
      rethrow;
    }
  }
}
