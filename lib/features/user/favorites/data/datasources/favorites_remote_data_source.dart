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

      final resData = response.data;
      List listData = [];

      if (resData is List) {
        listData = resData;
      } else if (resData is Map) {
        final resMap = Map<String, dynamic>.from(resData);
        if (resMap['data'] is List) {
          listData = resMap['data'] as List;
        } else if (resMap['data'] is Map) {
          final dataMap = Map<String, dynamic>.from(resMap['data'] as Map);
          if (dataMap['favorites'] is List) {
            listData = dataMap['favorites'] as List;
          } else if (dataMap['trips'] is List) {
            listData = dataMap['trips'] as List;
          } else if (dataMap['items'] is List) {
            listData = dataMap['items'] as List;
          }
        } else if (resMap['favorites'] is List) {
          listData = resMap['favorites'] as List;
        } else if (resMap['trips'] is List) {
          listData = resMap['trips'] as List;
        }
      }

      final trips = <TripModel>[];
      for (final item in listData) {
        if (item is Map) {
          final itemMap = Map<String, dynamic>.from(item);
          if (itemMap['trip'] != null && itemMap['trip'] is Map) {
            trips.add(
              TripModel.fromJson(
                Map<String, dynamic>.from(itemMap['trip'] as Map),
              ),
            );
          } else if (itemMap['tripId'] != null && itemMap['tripId'] is Map) {
            trips.add(
              TripModel.fromJson(
                Map<String, dynamic>.from(itemMap['tripId'] as Map),
              ),
            );
          } else if (itemMap['title'] != null ||
              itemMap['_id'] != null ||
              itemMap['id'] != null) {
            trips.add(TripModel.fromJson(itemMap));
          }
        }
      }
      return trips;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message']?.toString() ?? e.message ?? 'فشل جلب المفضلة';
      throw Exception(msg);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> toggleFavorite(String tripId) async {
    try {
      Response response;
      try {
        response = await dioClient.dio.post(
          '${ApiEndpoints.favorites}/$tripId',
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          try {
            response = await dioClient.dio.post(
              '${ApiEndpoints.favorites}/toggle/$tripId',
            );
          } on DioException catch (_) {
            response = await dioClient.dio.post(
              ApiEndpoints.favorites,
              data: {'tripId': tripId},
            );
          }
        } else {
          rethrow;
        }
      }

      final resData = response.data;
      if (resData is Map) {
        final resMap = Map<String, dynamic>.from(resData);
        if (resMap['data'] is Map) {
          final dataMap = Map<String, dynamic>.from(resMap['data'] as Map);
          if (dataMap.containsKey('isFavorite')) {
            return dataMap['isFavorite'] as bool? ?? false;
          }
        }
        if (resMap.containsKey('isFavorite')) {
          return resMap['isFavorite'] as bool? ?? false;
        }
      }
      return true;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message']?.toString() ?? e.message ?? 'فشل تحديث المفضلة';
      throw Exception(msg);
    } catch (e) {
      rethrow;
    }
  }
}
