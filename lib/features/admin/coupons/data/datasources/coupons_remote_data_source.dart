import 'package:fosha_app/core/network/api_endpoints.dart';
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
    final response = await _dioClient.dio.get(ApiEndpoints.coupons);
    return _extractCouponsList(response.data);
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
      ApiEndpoints.coupons,
      data: {
        'code': code.toUpperCase(),
        'discountPercentage': discountPercentage,
        'maxDiscountAmount': maxDiscountAmount,
        'minTripPrice': minTripPrice,
        'validUntil': validUntil.toIso8601String(),
        'usageLimit': usageLimit,
      },
    );

    return CouponModel.fromJson(_extractCouponMap(response.data));
  }

  @override
  Future<void> deleteCoupon(String couponId) async {
    await _dioClient.dio.delete('${ApiEndpoints.coupons}/$couponId');
  }

  List<CouponModel> _extractCouponsList(dynamic res) {
    final data = res?['data'];
    final list = (data is Map ? data['coupons'] : data) as List? ?? (res is List ? res : []);
    return list
        .map((e) => CouponModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> _extractCouponMap(dynamic res) {
    final data = res?['data'];
    return (data?['coupon'] ?? data ?? res ?? {}) as Map<String, dynamic>;
  }
}
