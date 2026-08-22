import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/user/favorites/data/repositories/favorites_repository.dart';
import 'package:fosha_app/features/user/favorites/presentation/cubit/favorites_state.dart';
export 'package:fosha_app/features/user/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;

  FavoritesCubit({required this.repository}) : super(const FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    final result = await repository.getFavorites();

    result.fold(
      (failure) => emit(FavoritesFailure(error: failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites: favorites)),
    );
  }

  Future<void> toggleFavorite(String tripId) async {
    final result = await repository.toggleFavorite(tripId);

    await result.fold(
      (failure) async {},
      (isFav) async {
        final currentState = state;
        if (currentState is FavoritesLoaded) {
          if (isFav) {
            await loadFavorites();
          } else {
            final updatedList = currentState.favorites
                .where((trip) => trip.id != tripId)
                .toList();
            emit(FavoritesLoaded(favorites: updatedList));
          }
        } else {
          await loadFavorites();
        }
      },
    );
  }
}
