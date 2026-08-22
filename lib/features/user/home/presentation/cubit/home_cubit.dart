import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/user/home/data/repositories/home_repository.dart';
import 'package:fosha_app/features/user/home/presentation/cubit/home_state.dart';
export 'package:fosha_app/features/user/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(const HomeInitial());

  String _currentGovernorate = 'المنيا';

  String get currentGovernorate => _currentGovernorate;

  Future<void> fetchHomeData({String? governorate}) async {
    if (governorate != null && governorate.isNotEmpty) {
      _currentGovernorate = governorate;
    }
    emit(const HomeLoading());
    final result = await repository.getHomeData(
      governorate: _currentGovernorate,
    );

    result.fold(
      (failure) => emit(HomeFailure(error: failure.message)),
      (homeData) => emit(HomeSuccess(homeData: homeData)),
    );
  }

  void changeGovernorate(String governorate) {
    _currentGovernorate = governorate;
    fetchHomeData(governorate: governorate);
  }
}
