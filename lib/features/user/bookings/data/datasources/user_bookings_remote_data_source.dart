import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';

abstract class UserBookingsRemoteDataSource {
  Future<BookingModel> createBooking({
    required String tripId,
    required int numberOfSeats,
    String? pickupPoint,
    String? pickupTime,
    String? paymentMethod,
    String? paymentSenderInstaPay,
    String? paymentSenderNumber,
    String? paymentNotes,
    String? notes,
    String? couponCode,
    List<Map<String, dynamic>>? passengers,
  });

  Future<List<BookingModel>> getMyBookings({String? status});

  Future<bool> cancelBooking(String bookingId);
}

class UserBookingsRemoteDataSourceImpl
    implements UserBookingsRemoteDataSource {
  final DioClient dioClient;

  UserBookingsRemoteDataSourceImpl({required this.dioClient});

  List _extractBookingsList(dynamic rawData) {
    if (rawData is Map<String, dynamic>) {
      final innerData = rawData['data'];
      if (innerData is Map<String, dynamic> && innerData['bookings'] is List) {
        return innerData['bookings'] as List;
      }
      if (innerData is List) return innerData;
      if (rawData['bookings'] is List) return rawData['bookings'] as List;
    } else if (rawData is List) {
      return rawData;
    }
    return [];
  }

  @override
  Future<BookingModel> createBooking({
    required String tripId,
    required int numberOfSeats,
    String? pickupPoint,
    String? pickupTime,
    String? paymentMethod,
    String? paymentSenderInstaPay,
    String? paymentSenderNumber,
    String? paymentNotes,
    String? notes,
    String? couponCode,
    List<Map<String, dynamic>>? passengers,
  }) async {
    final body = <String, dynamic>{
      'tripId': tripId,
      'numberOfSeats': numberOfSeats,
    };

    if (pickupPoint != null && pickupPoint.trim().isNotEmpty) {
      body['pickupPoint'] = pickupPoint.trim();
    }
    if (pickupTime != null && pickupTime.trim().isNotEmpty) {
      body['pickupTime'] = pickupTime.trim();
    }
    if (paymentMethod != null && paymentMethod.trim().isNotEmpty) {
      body['paymentMethod'] = paymentMethod.trim();
    }
    if (paymentSenderInstaPay != null && paymentSenderInstaPay.trim().isNotEmpty) {
      body['paymentSenderInstaPay'] = paymentSenderInstaPay.trim();
    }
    if (paymentSenderNumber != null && paymentSenderNumber.trim().isNotEmpty) {
      body['paymentSenderNumber'] = paymentSenderNumber.trim();
    }
    if (paymentNotes != null && paymentNotes.trim().isNotEmpty) {
      body['paymentNotes'] = paymentNotes.trim();
    }
    if (notes != null && notes.trim().isNotEmpty) {
      body['notes'] = notes.trim();
    }
    if (couponCode != null && couponCode.trim().isNotEmpty) {
      body['couponCode'] = couponCode.trim();
    }
    if (passengers != null && passengers.isNotEmpty) {
      body['passengers'] = passengers;
    }

    final response = await dioClient.dio.post(
      ApiEndpoints.bookings,
      data: body,
    );

    final resData = response.data as Map<String, dynamic>;
    final dataMap = (resData['data'] is Map<String, dynamic>)
        ? resData['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    return BookingModel.fromJson(dataMap);
  }

  @override
  Future<List<BookingModel>> getMyBookings({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null && status.isNotEmpty && status != 'all') {
      queryParams['status'] = status;
    }

    final response = await dioClient.dio.get(
      '${ApiEndpoints.bookings}/my',
      queryParameters: queryParams,
    );

    final list = _extractBookingsList(response.data);
    final allBookings = list
        .map((item) => BookingModel.fromJson(
            Map<String, dynamic>.from(item as Map)))
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
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final response = await dioClient.dio.post(
        '${ApiEndpoints.bookings}/$bookingId/cancel',
      );
      return response.statusCode == 200;
    } on DioException catch (_) {
      final response = await dioClient.dio.patch(
        '${ApiEndpoints.bookings}/$bookingId',
        data: {'status': 'cancelled'},
      );
      return response.statusCode == 200;
    }
  }
}
