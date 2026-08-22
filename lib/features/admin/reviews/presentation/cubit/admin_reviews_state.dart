import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/reviews/data/models/company_review_model.dart';

abstract class AdminReviewsState extends Equatable {
  const AdminReviewsState();

  @override
  List<Object?> get props => [];
}

class AdminReviewsInitial extends AdminReviewsState {}

class AdminReviewsLoading extends AdminReviewsState {}

class AdminReviewsLoaded extends AdminReviewsState {
  final CompanyReviewsResponseModel data;

  const AdminReviewsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class AdminReviewsError extends AdminReviewsState {
  final String message;

  const AdminReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
