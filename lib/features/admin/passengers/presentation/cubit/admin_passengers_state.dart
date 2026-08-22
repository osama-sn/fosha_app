import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/passengers/data/models/passenger_model.dart';

abstract class AdminPassengersState extends Equatable {
  const AdminPassengersState();

  @override
  List<Object?> get props => [];
}

class AdminPassengersInitial extends AdminPassengersState {}

class AdminPassengersLoading extends AdminPassengersState {}

class AdminPassengersLoaded extends AdminPassengersState {
  final PassengerListResponseModel data;

  const AdminPassengersLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class AdminPassengersError extends AdminPassengersState {
  final String message;

  const AdminPassengersError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminAnnouncementSentSuccess extends AdminPassengersState {
  final String message;

  const AdminAnnouncementSentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminAnnouncementError extends AdminPassengersState {
  final String message;

  const AdminAnnouncementError(this.message);

  @override
  List<Object?> get props => [message];
}
