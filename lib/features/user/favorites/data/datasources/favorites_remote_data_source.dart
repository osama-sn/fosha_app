import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<TripModel>> getFavorites({int page = 1, int limit = 10});
  Future<bool> toggleFavorite(String tripId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final DioClient dioClient;

  FavoritesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<TripModel>> getFavorites({int page = 1, int limit = 10}) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.favorites,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final resData = response.data as Map<String, dynamic>;
      final dataMap = (resData['data'] is Map<String, dynamic>)
          ? resData['data'] as Map<String, dynamic>
          : <String, dynamic>{};

      final favoritesList = dataMap['favorites'] as List? ?? [];

      final trips = <TripModel>[];
      for (final item in favoritesList) {
        if (item is Map && item['trip'] != null && item['trip'] is Map) {
          trips.add(TripModel.fromJson(Map<String, dynamic>.from(item['trip'] as Map)));
        }
      }
      return trips;
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ?? e.message ?? 'فشل جلب المفضلة';
      throw Exception(msg);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> toggleFavorite(String tripId) async {
    try {
      final response = await dioClient.dio.post(
        '${ApiEndpoints.favorites}/toggle/$tripId',
      );

      final resData = response.data as Map<String, dynamic>;
      final dataMap = (resData['data'] is Map<String, dynamic>)
          ? resData['data'] as Map<String, dynamic>
          : <String, dynamic>{};

      return dataMap['isFavorite'] as bool? ?? false;
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ?? e.message ?? 'فشل تحديث المفضلة';
      throw Exception(msg);
    } catch (e) {
      rethrow;
    }
  }
}
