import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import '../models/passenger_model.dart';

abstract class AdminPassengersRemoteDataSource {
  Future<PassengerListResponseModel> getTripPassengers(String tripId);
  Future<void> sendAnnouncement({
    required String tripId,
    required String title,
    required String message,
  });
}

class AdminPassengersRemoteDataSourceImpl
    implements AdminPassengersRemoteDataSource {
  final DioClient _dioClient;

  AdminPassengersRemoteDataSourceImpl(this._dioClient);

  @override
  Future<PassengerListResponseModel> getTripPassengers(String tripId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.tripPassengers(tripId),
    );
    return PassengerListResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<void> sendAnnouncement({
    required String tripId,
    required String title,
    required String message,
  }) async {
    await _dioClient.dio.post(
      ApiEndpoints.tripAnnouncements(tripId),
      data: {
        'title': title,
        'message': message,
      },
    );
  }
}
