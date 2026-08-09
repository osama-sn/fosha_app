import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/user/bookings/data/datasources/user_bookings_remote_data_source.dart';

class UserBookingsRepository {
  final UserBookingsRemoteDataSource dataSource;

  UserBookingsRepository({required this.dataSource});

  Future<BookingModel> createBooking({
    required String tripId,
    required int numberOfSeats,
    String? notes,
  }) async {
    return await dataSource.createBooking(
      tripId: tripId,
      numberOfSeats: numberOfSeats,
      notes: notes,
    );
  }

  Future<List<BookingModel>> getMyBookings({String? status}) async {
    return await dataSource.getMyBookings(status: status);
  }

  Future<bool> cancelBooking(String bookingId) async {
    return await dataSource.cancelBooking(bookingId);
  }
}
