import '../datasources/admin_passengers_remote_data_source.dart';
import '../models/passenger_model.dart';

class AdminPassengersRepository {
  final AdminPassengersRemoteDataSource _dataSource;

  AdminPassengersRepository(this._dataSource);

  Future<PassengerListResponseModel> getTripPassengers(String tripId) {
    return _dataSource.getTripPassengers(tripId);
  }

  Future<void> sendAnnouncement({
    required String tripId,
    required String title,
    required String message,
  }) {
    return _dataSource.sendAnnouncement(
      tripId: tripId,
      title: title,
      message: message,
    );
  }
}
