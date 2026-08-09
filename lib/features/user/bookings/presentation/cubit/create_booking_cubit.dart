import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/user/bookings/data/repositories/user_bookings_repository.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/create_booking_state.dart';

class CreateBookingCubit extends Cubit<CreateBookingState> {
  final UserBookingsRepository repository;

  CreateBookingCubit({required this.repository})
      : super(const CreateBookingInitial());

  Future<void> createBooking({
    required String tripId,
    required int numberOfSeats,
    String? notes,
  }) async {
    emit(const CreateBookingLoading());
    try {
      final booking = await repository.createBooking(
        tripId: tripId,
        numberOfSeats: numberOfSeats,
        notes: notes,
      );
      emit(CreateBookingSuccess(booking: booking));
    } catch (e) {
      emit(CreateBookingFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
