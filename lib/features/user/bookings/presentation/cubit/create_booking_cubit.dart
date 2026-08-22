import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/user/bookings/data/repositories/user_bookings_repository.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/create_booking_state.dart';
export 'package:fosha_app/features/user/bookings/presentation/cubit/create_booking_state.dart';

class CreateBookingCubit extends Cubit<CreateBookingState> {
  final UserBookingsRepository repository;

  CreateBookingCubit({required this.repository})
      : super(const CreateBookingInitial());

  Future<void> createBooking({
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
    emit(const CreateBookingLoading());
    final result = await repository.createBooking(
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

    result.fold(
      (failure) => emit(CreateBookingFailure(error: failure.message)),
      (booking) => emit(CreateBookingSuccess(booking: booking)),
    );
  }
}
