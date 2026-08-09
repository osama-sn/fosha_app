import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/user/favorites/data/datasources/favorites_remote_data_source.dart';

class FavoritesRepository {
  final FavoritesRemoteDataSource dataSource;

  FavoritesRepository({required this.dataSource});

  Future<List<TripModel>> getFavorites({int page = 1, int limit = 10}) async {
    return await dataSource.getFavorites(page: page, limit: limit);
  }

  Future<bool> toggleFavorite(String tripId) async {
    return await dataSource.toggleFavorite(tripId);
  }
}
