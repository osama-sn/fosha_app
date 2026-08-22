import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/user/bookings/data/datasources/user_bookings_remote_data_source.dart';

class UserBookingsRepository {
  final UserBookingsRemoteDataSource dataSource;

  UserBookingsRepository({required this.dataSource});

  Future<Either<Failure, BookingModel>> createBooking({
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
    try {
      final booking = await dataSource.createBooking(
        tripId: tripId,
        numberOfSeats: numberOfSeats,
        pickupPoint: pickupPoint,
        pickupTime: pickupTime,
        paymentMethod: paymentMethod,
        paymentSenderInstaPay: paymentSenderInstaPay,
        paymentSenderNumber: paymentSenderNumber,
        paymentNotes: paymentNotes,
        notes: notes,
        couponCode: couponCode,
        passengers: passengers,
      );
      return Right(booking);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, List<BookingModel>>> getMyBookings(
      {String? status}) async {
    try {
      final bookings = await dataSource.getMyBookings(status: status);
      return Right(bookings);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, bool>> cancelBooking(String bookingId) async {
    try {
      final success = await dataSource.cancelBooking(bookingId);
      return Right(success);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
