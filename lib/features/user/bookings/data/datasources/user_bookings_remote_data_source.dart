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
      List bookingsList = [];
      if (resData['data'] is Map && resData['data']['bookings'] is List) {
        bookingsList = resData['data']['bookings'] as List;
      } else if (resData['data'] is List) {
        bookingsList = resData['data'] as List;
      } else if (resData['bookings'] is List) {
        bookingsList = resData['bookings'] as List;
      }

      final allBookings = bookingsList
          .map((item) => BookingModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();

      if (status == null || status.isEmpty || status == 'all') {
        return allBookings;
      }

      final targetStatus = status.toLowerCase();
      return allBookings.where((b) {
        final s = b.status.toLowerCase();
        if (targetStatus == 'approved' ||
            targetStatus == 'accepted' ||
            targetStatus == 'confirmed') {
          return s == 'approved' || s == 'accepted' || s == 'confirmed';
        }
        return s == targetStatus;
      }).toList();
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
