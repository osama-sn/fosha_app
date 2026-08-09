import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';

abstract class CreateBookingState extends Equatable {
  const CreateBookingState();

  @override
  List<Object?> get props => [];
}

class CreateBookingInitial extends CreateBookingState {
  const CreateBookingInitial();
}

class CreateBookingLoading extends CreateBookingState {
  const CreateBookingLoading();
}

class CreateBookingSuccess extends CreateBookingState {
  final BookingModel booking;

  const CreateBookingSuccess({required this.booking});

  @override
  List<Object?> get props => [booking];
}

class CreateBookingFailure extends CreateBookingState {
  final String error;

  const CreateBookingFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
