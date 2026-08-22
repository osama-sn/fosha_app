import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/user/favorites/data/datasources/favorites_remote_data_source.dart';

class FavoritesRepository {
  final FavoritesRemoteDataSource dataSource;

  FavoritesRepository({required this.dataSource});

  Future<Either<Failure, List<TripModel>>> getFavorites(
      {int page = 1, int limit = 10}) async {
    try {
      final favorites = await dataSource.getFavorites(page: page, limit: limit);
      return Right(favorites);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, bool>> toggleFavorite(String tripId) async {
    try {
      final isFav = await dataSource.toggleFavorite(tripId);
      return Right(isFav);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
