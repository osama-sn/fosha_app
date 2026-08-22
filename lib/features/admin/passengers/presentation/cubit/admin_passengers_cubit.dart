import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/admin/passengers/data/repositories/admin_passengers_repository.dart';
import 'admin_passengers_state.dart';
export 'admin_passengers_state.dart';

class AdminPassengersCubit extends Cubit<AdminPassengersState> {
  final AdminPassengersRepository _repository;

  AdminPassengersCubit(this._repository) : super(AdminPassengersInitial());

  Future<void> fetchPassengers(String tripId) async {
    emit(AdminPassengersLoading());
    final result = await _repository.getTripPassengers(tripId);

    result.fold(
      (failure) => emit(AdminPassengersError(failure.message)),
      (data) => emit(AdminPassengersLoaded(data)),
    );
  }

  Future<void> sendAnnouncement({
    required String tripId,
    required String title,
    required String message,
  }) async {
    final result = await _repository.sendAnnouncement(
      tripId: tripId,
      title: title,
      message: message,
    );

    result.fold(
      (failure) => emit(AdminAnnouncementError(failure.message)),
      (_) => emit(const AdminAnnouncementSentSuccess('تم إرسال الإشعار بنجاح')),
    );
  }
}
