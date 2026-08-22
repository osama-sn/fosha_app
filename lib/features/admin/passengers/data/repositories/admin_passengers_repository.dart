import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import '../datasources/admin_passengers_remote_data_source.dart';
import '../models/passenger_model.dart';

class AdminPassengersRepository {
  final AdminPassengersRemoteDataSource _dataSource;

  AdminPassengersRepository(this._dataSource);

  Future<Either<Failure, PassengerListResponseModel>> getTripPassengers(
      String tripId) async {
    try {
      final response = await _dataSource.getTripPassengers(tripId);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, void>> sendAnnouncement({
    required String tripId,
    required String title,
    required String message,
  }) async {
    try {
      await _dataSource.sendAnnouncement(
        tripId: tripId,
        title: title,
        message: message,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
