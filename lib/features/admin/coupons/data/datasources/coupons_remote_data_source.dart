import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/coupons/data/models/coupon_model.dart';

abstract class CouponsRemoteDataSource {
  Future<List<CouponModel>> getCompanyCoupons();
  Future<CouponModel> createCoupon({
    required String code,
    required double discountPercentage,
    required double maxDiscountAmount,
    required double minTripPrice,
    required DateTime validUntil,
    required int usageLimit,
  });
  Future<void> deleteCoupon(String couponId);
}

class CouponsRemoteDataSourceImpl implements CouponsRemoteDataSource {
  final DioClient _dioClient;

  CouponsRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<CouponModel>> getCompanyCoupons() async {
    final response = await _dioClient.dio.get('/coupons');
    final responseData = response.data;
    List dynamicList = [];

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is List) {
        dynamicList = responseData['data'] as List;
      } else if (responseData['data'] is Map &&
          responseData['data']['coupons'] is List) {
        dynamicList = responseData['data']['coupons'] as List;
      }
    } else if (responseData is List) {
      dynamicList = responseData;
    }

    return dynamicList
        .map((e) => CouponModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CouponModel> createCoupon({
    required String code,
    required double discountPercentage,
    required double maxDiscountAmount,
    required double minTripPrice,
    required DateTime validUntil,
    required int usageLimit,
  }) async {
    final response = await _dioClient.dio.post(
      '/coupons',
      data: {
        'code': code.toUpperCase(),
        'discountPercentage': discountPercentage,
        'maxDiscountAmount': maxDiscountAmount,
        'minTripPrice': minTripPrice,
        'validUntil': validUntil.toIso8601String(),
        'usageLimit': usageLimit,
      },
    );

    final responseData = response.data;
    Map<String, dynamic> couponJson;
    if (responseData is Map<String, dynamic> && responseData['data'] != null) {
      couponJson = responseData['data'] is Map
          ? responseData['data'] as Map<String, dynamic>
          : responseData;
    } else {
      couponJson = responseData as Map<String, dynamic>;
    }

    return CouponModel.fromJson(couponJson);
  }

  @override
  Future<void> deleteCoupon(String couponId) async {
    await _dioClient.dio.delete('/coupons/$couponId');
  }
}
