import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/admin/reviews/data/repositories/admin_reviews_repository.dart';
import 'admin_reviews_state.dart';
export 'admin_reviews_state.dart';

class AdminReviewsCubit extends Cubit<AdminReviewsState> {
  final AdminReviewsRepository _repository;

  AdminReviewsCubit(this._repository) : super(AdminReviewsInitial());

  Future<void> fetchCompanyReviews(String companyId) async {
    emit(AdminReviewsLoading());
    final result = await _repository.getCompanyReviews(companyId);

    result.fold(
      (failure) => emit(AdminReviewsError(failure.message)),
      (data) => emit(AdminReviewsLoaded(data)),
    );
  }
}
