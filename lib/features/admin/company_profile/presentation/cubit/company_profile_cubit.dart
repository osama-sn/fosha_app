import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/admin/company_profile/data/repositories/company_profile_repository.dart';
import 'company_profile_state.dart';
export 'company_profile_state.dart';

class CompanyProfileCubit extends Cubit<CompanyProfileState> {
  final CompanyProfileRepository repository;

  CompanyProfileCubit({required this.repository})
      : super(CompanyProfileInitial());

  Future<void> loadCompanyProfile(String companyId) async {
    emit(CompanyProfileLoading());
    final result = await repository.getCompanyProfile(companyId);

    result.fold(
      (failure) => emit(CompanyProfileFailure(error: failure.message)),
      (profile) => emit(CompanyProfileLoaded(profile: profile)),
    );
  }

  Future<void> updateCompanyProfile({
    required String companyId,
    required String name,
    required String description,
    required String contactPhone,
    required String contactEmail,
    required String address,
    required String governorate,
  }) async {
    final currentState = state;
    CompanyProfileModel? currentModel;
    if (currentState is CompanyProfileLoaded) {
      currentModel = currentState.profile;
    } else if (currentState is CompanyProfileUpdateSuccess) {
      currentModel = currentState.profile;
    }

    if (currentModel != null) {
      emit(CompanyProfileUpdating(currentProfile: currentModel));
    } else {
      emit(CompanyProfileLoading());
    }

    final updatedModel = currentModel != null
        ? currentModel.copyWith(
            name: name,
            description: description,
            contactPhone: contactPhone,
            contactEmail: contactEmail,
            address: address,
            governorate: governorate,
          )
        : CompanyProfileModel(
            id: companyId,
            name: name,
            description: description,
            contactPhone: contactPhone,
            contactEmail: contactEmail,
            address: address,
            governorate: governorate,
          );

    final result = await repository.updateCompanyProfile(
      companyId,
      updatedModel,
    );

    result.fold(
      (failure) => emit(CompanyProfileFailure(error: failure.message)),
      (profile) => emit(
        CompanyProfileUpdateSuccess(
          profile: profile,
          message: AppStrings.companyProfileUpdateSuccess,
        ),
      ),
    );
  }
}
