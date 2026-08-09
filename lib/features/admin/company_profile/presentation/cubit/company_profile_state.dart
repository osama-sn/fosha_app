import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';

abstract class CompanyProfileState extends Equatable {
  const CompanyProfileState();

  @override
  List<Object?> get props => [];
}

class CompanyProfileInitial extends CompanyProfileState {}

class CompanyProfileLoading extends CompanyProfileState {}

class CompanyProfileLoaded extends CompanyProfileState {
  final CompanyProfileModel profile;

  const CompanyProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class CompanyProfileUpdating extends CompanyProfileState {
  final CompanyProfileModel currentProfile;

  const CompanyProfileUpdating({required this.currentProfile});

  @override
  List<Object?> get props => [currentProfile];
}

class CompanyProfileUpdateSuccess extends CompanyProfileState {
  final CompanyProfileModel profile;
  final String message;

  const CompanyProfileUpdateSuccess({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

class CompanyProfileFailure extends CompanyProfileState {
  final String error;

  const CompanyProfileFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
