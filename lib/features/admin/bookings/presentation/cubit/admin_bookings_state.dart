import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/bookings/data/constants/admin_bookings_constants.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';

abstract class AdminBookingsState extends Equatable {
  const AdminBookingsState();

  @override
  List<Object?> get props => [];
}

class AdminBookingsInitial extends AdminBookingsState {}

class AdminBookingsLoading extends AdminBookingsState {}

class AdminBookingsLoaded extends AdminBookingsState {
  final List<BookingModel> bookings;
  final String activeStatusFilter;
  final String? selectedTripTitle;
  final bool isUpdatingStatus;
  final String? actionSuccessMessage;

  const AdminBookingsLoaded({
    required this.bookings,
    this.activeStatusFilter = AdminBookingsConstants.statusAll,
    this.selectedTripTitle,
    this.isUpdatingStatus = false,
    this.actionSuccessMessage,
  });

  AdminBookingsLoaded copyWith({
    List<BookingModel>? bookings,
    String? activeStatusFilter,
    String? selectedTripTitle,
    bool? isUpdatingStatus,
    String? actionSuccessMessage,
  }) {
    return AdminBookingsLoaded(
      bookings: bookings ?? this.bookings,
      activeStatusFilter: activeStatusFilter ?? this.activeStatusFilter,
      selectedTripTitle: selectedTripTitle ?? this.selectedTripTitle,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
      actionSuccessMessage: actionSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
        bookings,
        activeStatusFilter,
        selectedTripTitle,
        isUpdatingStatus,
        actionSuccessMessage,
      ];
}

class AdminBookingsError extends AdminBookingsState {
  final String message;

  const AdminBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}
