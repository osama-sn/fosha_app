import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/admin/coupons/data/datasources/coupons_remote_data_source.dart';
import 'package:fosha_app/features/admin/coupons/data/models/coupon_model.dart';

class CouponsRepository {
  final CouponsRemoteDataSource dataSource;

  CouponsRepository({required this.dataSource});

  Future<Either<Failure, List<CouponModel>>> getCompanyCoupons() async {
    try {
      final response = await dataSource.getCompanyCoupons();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, CouponModel>> createCoupon({
    required String code,
    required double discountPercentage,
    required double maxDiscountAmount,
    required double minTripPrice,
    required DateTime validUntil,
    required int usageLimit,
  }) async {
    try {
      final response = await dataSource.createCoupon(
        code: code,
        discountPercentage: discountPercentage,
        maxDiscountAmount: maxDiscountAmount,
        minTripPrice: minTripPrice,
        validUntil: validUntil,
        usageLimit: usageLimit,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, void>> deleteCoupon(String couponId) async {
    try {
      await dataSource.deleteCoupon(couponId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
