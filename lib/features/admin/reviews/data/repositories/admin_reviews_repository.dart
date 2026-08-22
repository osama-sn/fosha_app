import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import '../datasources/admin_reviews_remote_data_source.dart';
import '../models/company_review_model.dart';

class AdminReviewsRepository {
  final AdminReviewsRemoteDataSource _dataSource;

  AdminReviewsRepository(this._dataSource);

  Future<Either<Failure, CompanyReviewsResponseModel>> getCompanyReviews(
      String companyId) async {
    try {
      final response = await _dataSource.getCompanyReviews(companyId);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, List<CompanyReviewModel>>> getTripReviews(
      String tripId) async {
    try {
      final response = await _dataSource.getTripReviews(tripId);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
