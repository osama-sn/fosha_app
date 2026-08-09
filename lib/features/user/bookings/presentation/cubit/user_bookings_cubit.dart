import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/user/bookings/data/repositories/user_bookings_repository.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/user_bookings_state.dart';

class UserBookingsCubit extends Cubit<UserBookingsState> {
  final UserBookingsRepository repository;

  UserBookingsCubit({required this.repository})
      : super(const UserBookingsInitial());

  Future<void> fetchMyBookings({String status = 'all'}) async {
    emit(const UserBookingsLoading());
    try {
      final bookings = await repository.getMyBookings(status: status);
      emit(UserBookingsLoaded(bookings: bookings, selectedStatus: status));
    } catch (e) {
      emit(UserBookingsFailure(
        error: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await repository.cancelBooking(bookingId);
      final currentState = state;
      final currentStatus = (currentState is UserBookingsLoaded)
          ? currentState.selectedStatus
          : 'all';
      await fetchMyBookings(status: currentStatus);
    } catch (_) {}
  }
}
