class CouponModel {
  final String id;
  final String code;
  final double discountPercentage;
  final double maxDiscountAmount;
  final double minTripPrice;
  final DateTime validUntil;
  final int usageLimit;
  final int usedCount;
  final bool isActive;

  const CouponModel({
    required this.id,
    required this.code,
    required this.discountPercentage,
    required this.maxDiscountAmount,
    required this.minTripPrice,
    required this.validUntil,
    required this.usageLimit,
    required this.usedCount,
    required this.isActive,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      code: json['code'] as String? ?? '',
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      maxDiscountAmount:
          (json['maxDiscountAmount'] as num?)?.toDouble() ?? 0.0,
      minTripPrice: (json['minTripPrice'] as num?)?.toDouble() ?? 0.0,
      validUntil: json['validUntil'] != null
          ? DateTime.tryParse(json['validUntil'].toString()) ?? DateTime.now()
          : DateTime.now(),
      usageLimit: (json['usageLimit'] as num?)?.toInt() ?? 0,
      usedCount: (json['usedCount'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'discountPercentage': discountPercentage,
      'maxDiscountAmount': maxDiscountAmount,
      'minTripPrice': minTripPrice,
      'validUntil': validUntil.toIso8601String(),
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
    };
  }
}
