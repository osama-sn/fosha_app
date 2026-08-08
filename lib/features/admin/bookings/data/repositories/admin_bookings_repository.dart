import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/admin/bookings/data/datasources/admin_bookings_data_source.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';

class AdminBookingsRepository {
  final AdminBookingsDataSource _dataSource;

  AdminBookingsRepository({
    required AdminBookingsDataSource dataSource,
  }) : _dataSource = dataSource;

  Future<Either<Failure, List<BookingModel>>> getBookings({
    String? status,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await _dataSource.getBookings(
        status: status,
        page: page,
        limit: limit,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, BookingModel>> updateBookingStatus(
    String bookingId, {
    required String status,
    String? rejectionReason,
  }) async {
    try {
      final response = await _dataSource.updateBookingStatus(
        bookingId,
        status: status,
        rejectionReason: rejectionReason,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
