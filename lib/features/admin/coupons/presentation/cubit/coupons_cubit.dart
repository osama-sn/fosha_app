import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/features/admin/coupons/data/models/coupon_model.dart';
import 'package:fosha_app/features/admin/coupons/data/repositories/coupons_repository.dart';
import 'coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  final CouponsRepository repository;

  CouponsCubit({required this.repository}) : super(CouponsInitial());

  List<CouponModel> _currentCoupons = [];

  Future<void> fetchCompanyCoupons() async {
    emit(CouponsLoading());
    final result = await repository.getCompanyCoupons();

    result.fold(
      (failure) => emit(CouponsFailure(error: failure.message)),
      (coupons) {
        _currentCoupons = coupons;
        emit(CouponsLoaded(coupons: coupons));
      },
    );
  }

  Future<void> createCoupon({
    required String code,
    required double discountPercentage,
    required double maxDiscountAmount,
    required double minTripPrice,
    required DateTime validUntil,
    required int usageLimit,
  }) async {
    emit(CouponsSubmitting(currentCoupons: _currentCoupons));
    final createResult = await repository.createCoupon(
      code: code,
      discountPercentage: discountPercentage,
      maxDiscountAmount: maxDiscountAmount,
      minTripPrice: minTripPrice,
      validUntil: validUntil,
      usageLimit: usageLimit,
    );

    await createResult.fold(
      (failure) async => emit(CouponsFailure(error: failure.message)),
      (newCoupon) async {
        final fetchResult = await repository.getCompanyCoupons();
        fetchResult.fold(
          (failure) => emit(CouponsFailure(error: failure.message)),
          (updatedList) {
            _currentCoupons = updatedList;
            emit(CouponsActionSuccess(
              coupons: updatedList,
              message: AppStrings.couponCreatedSuccess,
            ));
          },
        );
      },
    );
  }

  Future<void> deleteCoupon(String couponId) async {
    emit(CouponsSubmitting(currentCoupons: _currentCoupons));
    final deleteResult = await repository.deleteCoupon(couponId);

    await deleteResult.fold(
      (failure) async => emit(CouponsFailure(error: failure.message)),
      (_) async {
        final fetchResult = await repository.getCompanyCoupons();
        fetchResult.fold(
          (failure) => emit(CouponsFailure(error: failure.message)),
          (updatedList) {
            _currentCoupons = updatedList;
            emit(CouponsActionSuccess(
              coupons: updatedList,
              message: AppStrings.couponDeletedSuccess,
            ));
          },
        );
      },
    );
  }
}
