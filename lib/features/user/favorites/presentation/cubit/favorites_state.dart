import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<TripModel> favorites;

  const FavoritesLoaded({required this.favorites});

  @override
  List<Object?> get props => [favorites];
}

class FavoritesFailure extends FavoritesState {
  final String error;

  const FavoritesFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
