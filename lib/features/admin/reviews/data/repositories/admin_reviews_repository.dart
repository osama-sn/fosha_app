import '../datasources/admin_reviews_remote_data_source.dart';
import '../models/company_review_model.dart';

class AdminReviewsRepository {
  final AdminReviewsRemoteDataSource _dataSource;

  AdminReviewsRepository(this._dataSource);

  Future<CompanyReviewsResponseModel> getCompanyReviews(String companyId) {
    return _dataSource.getCompanyReviews(companyId);
  }

  Future<List<CompanyReviewModel>> getTripReviews(String tripId) {
    return _dataSource.getTripReviews(tripId);
  }
}
