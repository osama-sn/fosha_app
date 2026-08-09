import 'package:dio/dio.dart';
import 'package:fosha_app/features/admin/coupons/data/datasources/coupons_remote_data_source.dart';
import 'package:fosha_app/features/admin/coupons/data/models/coupon_model.dart';

class CouponsRepository {
  final CouponsRemoteDataSource dataSource;

  CouponsRepository({required this.dataSource});

  Future<List<CouponModel>> getCompanyCoupons() async {
    try {
      return await dataSource.getCompanyCoupons();
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : 'فشل في جلب كروت الكوبونات';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<CouponModel> createCoupon({
    required String code,
    required double discountPercentage,
    required double maxDiscountAmount,
    required double minTripPrice,
    required DateTime validUntil,
    required int usageLimit,
  }) async {
    try {
      return await dataSource.createCoupon(
        code: code,
        discountPercentage: discountPercentage,
        maxDiscountAmount: maxDiscountAmount,
        minTripPrice: minTripPrice,
        validUntil: validUntil,
        usageLimit: usageLimit,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : 'فشل في إنشاء كود الخصم';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    try {
      await dataSource.deleteCoupon(couponId);
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : 'فشل في حذف الكوبون';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
