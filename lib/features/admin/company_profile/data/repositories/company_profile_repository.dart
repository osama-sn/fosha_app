import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/admin/company_profile/data/datasources/company_profile_remote_data_source.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_payment_account_model.dart';
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

  Future<Either<Failure, List<CompanyPaymentAccountModel>>> getPaymentAccounts(
    String companyId,
  ) async {
    try {
      final response = await dataSource.getPaymentAccounts(companyId);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, CompanyPaymentAccountModel>> addPaymentAccount(
    String companyId,
    CompanyPaymentAccountModel account,
  ) async {
    try {
      final response = await dataSource.addPaymentAccount(
        companyId,
        account.toJson(),
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, CompanyPaymentAccountModel>> updatePaymentAccount(
    String companyId,
    String accountId,
    CompanyPaymentAccountModel account,
  ) async {
    try {
      final response = await dataSource.updatePaymentAccount(
        companyId,
        accountId,
        account.toJson(),
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, CompanyPaymentAccountModel>> togglePaymentAccount(
    String companyId,
    String accountId,
  ) async {
    try {
      final response = await dataSource.togglePaymentAccount(
        companyId,
        accountId,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, Unit>> deletePaymentAccount(
    String companyId,
    String accountId,
  ) async {
    try {
      await dataSource.deletePaymentAccount(companyId, accountId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
