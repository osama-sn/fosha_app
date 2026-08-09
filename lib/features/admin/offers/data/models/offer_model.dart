class OfferModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String image;
  final String? tripId;
  final String? tripTitle;
  final double discountPercentage;
  final String promoCode;
  final DateTime? startDate;
  final DateTime? endDate;
  final int priority;
  final bool isActive;

  const OfferModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.image,
    this.tripId,
    this.tripTitle,
    required this.discountPercentage,
    required this.promoCode,
    this.startDate,
    this.endDate,
    required this.priority,
    required this.isActive,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    String? tripId;
    String? tripTitle;

    if (json['trip'] != null) {
      if (json['trip'] is Map) {
        tripId = (json['trip']['_id'] ?? json['trip']['id'])?.toString();
        tripTitle = json['trip']['title']?.toString();
      } else {
        tripId = json['trip'].toString();
      }
    }

    return OfferModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      titleAr: json['titleAr'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      image: json['image'] as String? ?? '',
      tripId: tripId,
      tripTitle: tripTitle,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      promoCode: json['promoCode'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString())
          : null,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'image': image,
      if (tripId != null) 'trip': tripId,
      'discountPercentage': discountPercentage,
      'promoCode': promoCode,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      'priority': priority,
      'isActive': isActive,
    };
  }
}
