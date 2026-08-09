import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';

abstract class UserBookingsRemoteDataSource {
  Future<BookingModel> createBooking({
    required String tripId,
    required int numberOfSeats,
    String? notes,
  });

  Future<List<BookingModel>> getMyBookings({String? status});

  Future<bool> cancelBooking(String bookingId);
}

class UserBookingsRemoteDataSourceImpl implements UserBookingsRemoteDataSource {
  final DioClient dioClient;

  UserBookingsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<BookingModel> createBooking({
    required String tripId,
    required int numberOfSeats,
    String? notes,
  }) async {
    try {
      final body = <String, dynamic>{
        'tripId': tripId,
        'numberOfSeats': numberOfSeats,
      };

      if (notes != null && notes.trim().isNotEmpty) {
        body['notes'] = notes.trim();
      }

      final response = await dioClient.dio.post(
        ApiEndpoints.bookings,
        data: body,
      );

      final resData = response.data as Map<String, dynamic>;
      final dataMap = (resData['data'] is Map<String, dynamic>)
          ? resData['data'] as Map<String, dynamic>
          : (resData['data'] is Map
              ? Map<String, dynamic>.from(resData['data'] as Map)
              : <String, dynamic>{});

      return BookingModel.fromJson(dataMap);
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message']?.toString() ?? e.message ?? 'Booking error';
      throw Exception(errorMsg);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BookingModel>> getMyBookings({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status;
      }

      final response = await dioClient.dio.get(
        '${ApiEndpoints.bookings}/my',
        queryParameters: queryParams,
      );

      final resData = response.data as Map<String, dynamic>;
      final dataMap = (resData['data'] is Map<String, dynamic>)
          ? resData['data'] as Map<String, dynamic>
          : <String, dynamic>{};

      final bookingsList = dataMap['bookings'] as List? ?? [];
      return bookingsList
          .map((item) => BookingModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message']?.toString() ?? e.message ?? 'فشل جلب الحجوزات';
      throw Exception(errorMsg);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final response = await dioClient.dio.post(
        '${ApiEndpoints.bookings}/$bookingId/cancel',
      );
      return response.statusCode == 200;
    } on DioException catch (_) {
      try {
        final response = await dioClient.dio.patch(
          '${ApiEndpoints.bookings}/$bookingId',
          data: {'status': 'cancelled'},
        );
        return response.statusCode == 200;
      } catch (e) {
        throw Exception('فشل إلغاء الحجز');
      }
    } catch (e) {
      rethrow;
    }
  }
}
