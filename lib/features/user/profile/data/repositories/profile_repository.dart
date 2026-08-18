import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/user/auth/data/models/user_model.dart';
import 'package:fosha_app/features/user/profile/data/datasources/profile_remote_data_source.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepository({required this.remoteDataSource});

  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      final user = await remoteDataSource.getProfile();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> updateProfile({
    String? fullName,
    String? phone,
    String? governorate,
    dynamic imageFile,
  }) async {
    try {
      final user = await remoteDataSource.updateProfile(
        fullName: fullName,
        phone: phone,
        governorate: governorate,
        imageFile: imageFile,
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
