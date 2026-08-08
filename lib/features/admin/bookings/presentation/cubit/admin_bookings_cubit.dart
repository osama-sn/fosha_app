import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/admin/bookings/data/repositories/admin_bookings_repository.dart';
import 'package:fosha_app/features/admin/bookings/presentation/cubit/admin_bookings_state.dart';

class AdminBookingsCubit extends Cubit<AdminBookingsState> {
  final AdminBookingsRepository _repository;

  AdminBookingsCubit({
    required AdminBookingsRepository repository,
  })  : _repository = repository,
        super(AdminBookingsInitial());

  Future<void> fetchBookings({String? statusFilter}) async {
    emit(AdminBookingsLoading());
    final result = await _repository.getBookings(status: statusFilter);

    result.fold(
      (failure) => emit(AdminBookingsError(failure.message)),
      (bookings) => emit(
        AdminBookingsLoaded(
          bookings: bookings,
          activeStatusFilter: statusFilter ?? 'all',
        ),
      ),
    );
  }

  Future<void> updateStatus({
    required String bookingId,
    required String newStatus,
    String? rejectionReason,
  }) async {
    final currentState = state;
    if (currentState is AdminBookingsLoaded) {
      emit(currentState.copyWith(isUpdatingStatus: true));

      final result = await _repository.updateBookingStatus(
        bookingId,
        status: newStatus,
        rejectionReason: rejectionReason,
      );

      result.fold(
        (failure) => emit(AdminBookingsError(failure.message)),
        (updatedBooking) {
          final updatedList = currentState.bookings.map((b) {
            return b.id == bookingId ? updatedBooking : b;
          }).toList();

          emit(
            currentState.copyWith(
              bookings: updatedList,
              isUpdatingStatus: false,
              actionSuccessMessage: newStatus == 'approved'
                  ? 'تم قبول طلب الحجز بنجاح'
                  : 'تم رفض طلب الحجز',
            ),
          );
        },
      );
    }
  }
}
