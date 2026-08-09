import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/coupons/data/models/coupon_model.dart';

abstract class CouponsState extends Equatable {
  const CouponsState();

  @override
  List<Object?> get props => [];
}

class CouponsInitial extends CouponsState {}

class CouponsLoading extends CouponsState {}

class CouponsLoaded extends CouponsState {
  final List<CouponModel> coupons;

  const CouponsLoaded({required this.coupons});

  @override
  List<Object?> get props => [coupons];
}

class CouponsSubmitting extends CouponsState {
  final List<CouponModel> currentCoupons;

  const CouponsSubmitting({required this.currentCoupons});

  @override
  List<Object?> get props => [currentCoupons];
}

class CouponsActionSuccess extends CouponsState {
  final List<CouponModel> coupons;
  final String message;

  const CouponsActionSuccess({
    required this.coupons,
    required this.message,
  });

  @override
  List<Object?> get props => [coupons, message];
}

class CouponsFailure extends CouponsState {
  final String error;

  const CouponsFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
