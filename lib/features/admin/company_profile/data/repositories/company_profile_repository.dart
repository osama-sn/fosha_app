import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/admin/company_profile/data/datasources/company_profile_remote_data_source.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_review_model.dart';

class CompanyProfileRepository {
  final CompanyProfileRemoteDataSource dataSource;

  CompanyProfileRepository({required this.dataSource});

  Future<Either<Failure, CompanyProfileModel>> getCompanyProfile(
    String companyId,
  ) async {
    try {
      final response = await dataSource.getCompanyProfile(companyId);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, CompanyProfileModel>> updateCompanyProfile(
    String companyId,
    CompanyProfileModel profile,
  ) async {
    try {
      final response = await dataSource.updateCompanyProfile(
        companyId,
        profile.toUpdateJson(),
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, List<CompanyReviewModel>>> getCompanyReviews(
    String companyId,
  ) async {
    try {
      final response = await dataSource.getCompanyReviews(companyId);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
