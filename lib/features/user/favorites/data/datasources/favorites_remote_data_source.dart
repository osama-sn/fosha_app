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

  List _extractFavoritesList(dynamic resData) {
    if (resData is List) return resData;
    if (resData is Map) {
      final resMap = Map<String, dynamic>.from(resData);
      final data = resMap['data'];
      if (data is List) return data;
      if (data is Map) {
        final dataMap = Map<String, dynamic>.from(data);
        for (final key in ['favorites', 'trips', 'items']) {
          if (dataMap[key] is List) return dataMap[key] as List;
        }
      }
      for (final key in ['favorites', 'trips']) {
        if (resMap[key] is List) return resMap[key] as List;
      }
    }
    return [];
  }

  TripModel? _parseFavoriteTripItem(dynamic item) {
    if (item is! Map) return null;
    final itemMap = Map<String, dynamic>.from(item);

    if (itemMap['trip'] is Map) {
      return TripModel.fromJson(Map<String, dynamic>.from(itemMap['trip'] as Map));
    }
    if (itemMap['tripId'] is Map) {
      return TripModel.fromJson(
          Map<String, dynamic>.from(itemMap['tripId'] as Map));
    }
    if (itemMap['title'] != null || itemMap['id'] != null) {
      return TripModel.fromJson(itemMap);
    }
    return null;
  }

  @override
  Future<List<TripModel>> getFavorites({int page = 1, int limit = 10}) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.favorites,
      queryParameters: {'page': page, 'limit': limit},
    );

    final rawList = _extractFavoritesList(response.data);
    final trips = <TripModel>[];

    for (final item in rawList) {
      final parsed = _parseFavoriteTripItem(item);
      if (parsed != null) trips.add(parsed);
    }

    return trips;
  }

  @override
  Future<bool> toggleFavorite(String tripId) async {
    Response response;
    try {
      response = await dioClient.dio.post('${ApiEndpoints.favorites}/$tripId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        try {
          response =
              await dioClient.dio.post('${ApiEndpoints.favorites}/toggle/$tripId');
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
      if (resMap['data'] is Map &&
          (resMap['data'] as Map).containsKey('isFavorite')) {
        return (resMap['data'] as Map)['isFavorite'] as bool? ?? false;
      }
      if (resMap.containsKey('isFavorite')) {
        return resMap['isFavorite'] as bool? ?? false;
      }
    }
    return true;
  }
}
