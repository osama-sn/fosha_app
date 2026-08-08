import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';

abstract class AdminBookingsDataSource {
  Future<List<BookingModel>> getBookings({
    String? status,
    int? page,
    int? limit,
  });

  Future<BookingModel> updateBookingStatus(
    String bookingId, {
    required String status,
    String? rejectionReason,
  });
}

class AdminBookingsDataSourceImpl implements AdminBookingsDataSource {
  final DioClient _dioClient;

  AdminBookingsDataSourceImpl(this._dioClient);

  @override
  Future<List<BookingModel>> getBookings({
    String? status,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null && status.isNotEmpty && status != 'all') {
        queryParameters['status'] = status;
      }
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _dioClient.dio.get(
        ApiEndpoints.bookings,
        queryParameters: queryParameters,
      );

      final dynamic data = response.data;
      List<dynamic> list = [];
      if (data is Map<String, dynamic>) {
        if (data['data'] is List) {
          list = data['data'] as List<dynamic>;
        } else if (data['data'] is Map && data['data']['bookings'] is List) {
          list = data['data']['bookings'] as List<dynamic>;
        }
      } else if (data is List) {
        list = data;
      }

      return list
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BookingModel> updateBookingStatus(
    String bookingId, {
    required String status,
    String? rejectionReason,
  }) async {
    try {
      final body = <String, dynamic>{
        'status': status,
        if (rejectionReason != null && rejectionReason.isNotEmpty)
          'rejectionReason': rejectionReason,
      };

      final response = await _dioClient.dio.patch(
        '${ApiEndpoints.bookings}/$bookingId/status',
        data: body,
      );

      final dynamic data = response.data;
      Map<String, dynamic> bookingJson = {};
      if (data is Map<String, dynamic>) {
        if (data['data'] is Map) {
          bookingJson = data['data'] as Map<String, dynamic>;
        } else {
          bookingJson = data;
        }
      }

      return BookingModel.fromJson(bookingJson);
    } catch (e) {
      rethrow;
    }
  }
}
