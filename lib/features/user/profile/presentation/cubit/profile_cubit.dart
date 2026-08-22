import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/user/profile/data/repositories/profile_repository.dart';
import 'profile_state.dart';
export 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    final result = await repository.getProfile();
    result.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (user) => emit(ProfileSuccess(user)),
    );
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? governorate,
    dynamic imageFile,
  }) async {
    emit(ProfileLoading());
    final result = await repository.updateProfile(
      fullName: fullName,
      phone: phone,
      governorate: governorate,
      imageFile: imageFile,
    );
    return result.fold(
      (failure) {
        emit(ProfileFailure(failure.message));
        return false;
      },
      (user) {
        emit(ProfileSuccess(user));
        return true;
      },
    );
  }
}
