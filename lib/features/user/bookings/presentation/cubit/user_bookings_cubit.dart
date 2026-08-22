import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/user/bookings/data/repositories/user_bookings_repository.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/user_bookings_state.dart';
export 'package:fosha_app/features/user/bookings/presentation/cubit/user_bookings_state.dart';

class UserBookingsCubit extends Cubit<UserBookingsState> {
  final UserBookingsRepository repository;

  UserBookingsCubit({required this.repository})
      : super(const UserBookingsInitial());

  Future<void> fetchMyBookings({String status = 'all'}) async {
    emit(const UserBookingsLoading());
    final result = await repository.getMyBookings(status: status);

    result.fold(
      (failure) => emit(UserBookingsFailure(error: failure.message)),
      (bookings) =>
          emit(UserBookingsLoaded(bookings: bookings, selectedStatus: status)),
    );
  }

  Future<void> cancelBooking(String bookingId) async {
    final result = await repository.cancelBooking(bookingId);

    await result.fold(
      (failure) async {},
      (_) async {
        final currentState = state;
        final currentStatus = (currentState is UserBookingsLoaded)
            ? currentState.selectedStatus
            : 'all';
        await fetchMyBookings(status: currentStatus);
      },
    );
  }
}
