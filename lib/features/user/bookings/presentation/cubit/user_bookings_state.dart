import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';

abstract class UserBookingsState extends Equatable {
  const UserBookingsState();

  @override
  List<Object?> get props => [];
}

class UserBookingsInitial extends UserBookingsState {
  const UserBookingsInitial();
}

class UserBookingsLoading extends UserBookingsState {
  const UserBookingsLoading();
}

class UserBookingsLoaded extends UserBookingsState {
  final List<BookingModel> bookings;
  final String selectedStatus;

  const UserBookingsLoaded({
    required this.bookings,
    this.selectedStatus = 'all',
  });

  @override
  List<Object?> get props => [bookings, selectedStatus];
}

class UserBookingsFailure extends UserBookingsState {
  final String error;

  const UserBookingsFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
