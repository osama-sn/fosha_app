import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/user/home/data/models/home_data_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeSuccess extends HomeState {
  final HomeDataModel homeData;

  const HomeSuccess({required this.homeData});

  @override
  List<Object?> get props => [homeData];
}

class HomeFailure extends HomeState {
  final String error;

  const HomeFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
