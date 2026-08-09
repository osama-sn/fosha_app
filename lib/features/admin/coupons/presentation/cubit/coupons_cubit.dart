import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/admin/coupons/data/models/coupon_model.dart';
import 'package:fosha_app/features/admin/coupons/data/repositories/coupons_repository.dart';
import 'coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  final CouponsRepository repository;

  CouponsCubit({required this.repository}) : super(CouponsInitial());

  List<CouponModel> _currentCoupons = [];

  Future<void> fetchCompanyCoupons() async {
    emit(CouponsLoading());
    try {
      final coupons = await repository.getCompanyCoupons();
      _currentCoupons = coupons;
      emit(CouponsLoaded(coupons: coupons));
    } catch (e) {
      emit(CouponsFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
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
    try {
      await repository.createCoupon(
        code: code,
        discountPercentage: discountPercentage,
        maxDiscountAmount: maxDiscountAmount,
        minTripPrice: minTripPrice,
        validUntil: validUntil,
        usageLimit: usageLimit,
      );
      final updatedList = await repository.getCompanyCoupons();
      _currentCoupons = updatedList;
      emit(CouponsActionSuccess(
        coupons: updatedList,
        message: 'تم إضاف الكوبون بنجاح',
      ));
    } catch (e) {
      emit(CouponsFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    emit(CouponsSubmitting(currentCoupons: _currentCoupons));
    try {
      await repository.deleteCoupon(couponId);
      final updatedList = await repository.getCompanyCoupons();
      _currentCoupons = updatedList;
      emit(CouponsActionSuccess(
        coupons: updatedList,
        message: 'تم حذف الكوبون بنجاح',
      ));
    } catch (e) {
      emit(CouponsFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
