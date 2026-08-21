import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/bookings/data/constants/admin_bookings_constants.dart';
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
    final queryParameters = <String, dynamic>{};
    if (status != null &&
        status.isNotEmpty &&
        status != AdminBookingsConstants.statusAll) {
      queryParameters[AdminBookingsConstants.paramStatus] = status;
    }
    if (page != null) {
      queryParameters[AdminBookingsConstants.paramPage] = page;
    }
    if (limit != null) {
      queryParameters[AdminBookingsConstants.paramLimit] = limit;
    }

    final response = await _dioClient.dio.get(
      ApiEndpoints.bookings,
      queryParameters: queryParameters,
    );

    final rawList = _extractBookingsList(response.data);
    return rawList
        .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BookingModel> updateBookingStatus(
    String bookingId, {
    required String status,
    String? rejectionReason,
  }) async {
    final response = await _executeStatusUpdate(
      bookingId,
      status: status,
      rejectionReason: rejectionReason,
    );

    final bookingJson = _extractBookingMap(response.data);
    return BookingModel.fromJson(bookingJson);
  }

  Future<Response> _executeStatusUpdate(
    String bookingId, {
    required String status,
    String? rejectionReason,
  }) async {
    final baseUrl = '${ApiEndpoints.bookings}/$bookingId';

    if (status == AdminBookingsConstants.statusApproved ||
        status == AdminBookingsConstants.statusAccepted) {
      return _patchWithFallback('$baseUrl/approve', {
        AdminBookingsConstants.paramStatus:
            AdminBookingsConstants.statusApproved,
      });
    }

    if (status == AdminBookingsConstants.statusRejected ||
        status == AdminBookingsConstants.statusCancelled) {
      final isRejected = status == AdminBookingsConstants.statusRejected;
      final reasonKey = isRejected
          ? AdminBookingsConstants.paramRejectionReason
          : AdminBookingsConstants.paramCancellationReason;
      final actionPath = isRejected ? 'reject' : 'cancel';

      final body = <String, dynamic>{
        if (rejectionReason != null && rejectionReason.isNotEmpty)
          reasonKey: rejectionReason,
      };

      return _patchWithFallback('$baseUrl/$actionPath', {
        AdminBookingsConstants.paramStatus: status,
        ...body,
      });
    }

    throw ArgumentError.value(status, 'status', 'Unsupported booking status');
  }

  Future<Response> _patchWithFallback(
    String primaryUrl,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _dioClient.dio.patch(primaryUrl, data: data);
    } catch (_) {
      rethrow;
    }
  }

  List<dynamic> _extractBookingsList(dynamic data) {
    if (data is Map<String, dynamic>) {
      final res =
          data[AdminBookingsConstants.keyData] ??
          data[AdminBookingsConstants.keyBookings];
      if (res is List) return res;
      if (res is Map && res[AdminBookingsConstants.keyBookings] is List) {
        return res[AdminBookingsConstants.keyBookings] as List;
      }
    }
    return data is List ? data : const [];
  }

  Map<String, dynamic> _extractBookingMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nested = data[AdminBookingsConstants.keyData];
      if (nested is Map<String, dynamic>) return nested;
      return data;
    }
    return const {};
  }
}
