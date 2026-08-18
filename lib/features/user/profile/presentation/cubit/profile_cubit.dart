import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/user/auth/data/models/user_model.dart';
import 'package:fosha_app/features/user/profile/data/repositories/profile_repository.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileSuccess extends ProfileState {
  final UserModel user;
  const ProfileSuccess(this.user);
  @override
  List<Object?> get props => [user];
}
class ProfileFailure extends ProfileState {
  final String error;
  const ProfileFailure(this.error);
  @override
  List<Object?> get props => [error];
}

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
