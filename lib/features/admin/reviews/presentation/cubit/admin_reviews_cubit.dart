import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/features/admin/reviews/data/models/company_review_model.dart';
import 'package:fosha_app/features/admin/reviews/data/repositories/admin_reviews_repository.dart';

abstract class AdminReviewsState {}

class AdminReviewsInitial extends AdminReviewsState {}

class AdminReviewsLoading extends AdminReviewsState {}

class AdminReviewsLoaded extends AdminReviewsState {
  final CompanyReviewsResponseModel data;
  AdminReviewsLoaded(this.data);
}

class AdminReviewsError extends AdminReviewsState {
  final String message;
  AdminReviewsError(this.message);
}

class AdminReviewsCubit extends Cubit<AdminReviewsState> {
  final AdminReviewsRepository _repository;

  AdminReviewsCubit(this._repository) : super(AdminReviewsInitial());

  Future<void> fetchCompanyReviews(String companyId) async {
    emit(AdminReviewsLoading());
    try {
      final res = await _repository.getCompanyReviews(companyId);
      emit(AdminReviewsLoaded(res));
    } catch (e) {
      emit(AdminReviewsError(ApiErrorHandler.handle(e)));
    }
  }
}
