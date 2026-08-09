import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchSuccess extends SearchState {
  final List<TripModel> trips;
  final int totalItems;
  final int totalPages;
  final int currentPage;

  const SearchSuccess({
    required this.trips,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [trips, totalItems, totalPages, currentPage];
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
