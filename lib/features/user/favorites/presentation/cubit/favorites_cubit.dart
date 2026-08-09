import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/user/favorites/data/repositories/favorites_repository.dart';
import 'package:fosha_app/features/user/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;

  FavoritesCubit({required this.repository}) : super(const FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    try {
      final favorites = await repository.getFavorites();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesFailure(
        error: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> toggleFavorite(String tripId) async {
    try {
      final isFav = await repository.toggleFavorite(tripId);
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        if (isFav) {
          // Re-fetch to get updated populated trip list
          await loadFavorites();
        } else {
          // Remove locally
          final updatedList = currentState.favorites
              .where((trip) => trip.id != tripId)
              .toList();
          emit(FavoritesLoaded(favorites: updatedList));
        }
      } else {
        await loadFavorites();
      }
    } catch (_) {}
  }
}
