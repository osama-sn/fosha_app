import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/features/admin/passengers/data/models/passenger_model.dart';
import 'package:fosha_app/features/admin/passengers/data/repositories/admin_passengers_repository.dart';

abstract class AdminPassengersState {}

class AdminPassengersInitial extends AdminPassengersState {}

class AdminPassengersLoading extends AdminPassengersState {}

class AdminPassengersLoaded extends AdminPassengersState {
  final PassengerListResponseModel data;
  AdminPassengersLoaded(this.data);
}

class AdminPassengersError extends AdminPassengersState {
  final String message;
  AdminPassengersError(this.message);
}

class AdminAnnouncementSending extends AdminPassengersState {}

class AdminAnnouncementSentSuccess extends AdminPassengersState {
  final String message;
  AdminAnnouncementSentSuccess(this.message);
}

class AdminAnnouncementError extends AdminPassengersState {
  final String message;
  AdminAnnouncementError(this.message);
}

class AdminPassengersCubit extends Cubit<AdminPassengersState> {
  final AdminPassengersRepository _repository;

  AdminPassengersCubit(this._repository) : super(AdminPassengersInitial());

  Future<void> fetchPassengers(String tripId) async {
    emit(AdminPassengersLoading());
    try {
      final res = await _repository.getTripPassengers(tripId);
      emit(AdminPassengersLoaded(res));
    } catch (e) {
      emit(AdminPassengersError(ApiErrorHandler.handle(e)));
    }
  }

  Future<void> sendAnnouncement({
    required String tripId,
    required String title,
    required String message,
  }) async {
    try {
      await _repository.sendAnnouncement(
        tripId: tripId,
        title: title,
        message: message,
      );
      emit(AdminAnnouncementSentSuccess('تم إرسال الإشعار بنجاح لجميع ركاب الرحلة'));
    } catch (e) {
      emit(AdminAnnouncementError(ApiErrorHandler.handle(e)));
    }
  }
}
