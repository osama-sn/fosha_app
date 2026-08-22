import 'company_payment_account_model.dart';

class CompanyProfileModel {
  final String id;
  final String name;
  final String description;
  final String contactPhone;
  final String contactEmail;
  final String address;
  final String governorate;
  final String? logo;
  final String? coverImage;
  final String? commissionType;
  final double? commissionValue;
  final double? monthlySubscriptionFee;
  final String? subscriptionStatus;
  final double? averageRating;
  final int? reviewsCount;
  final List<CompanyPaymentAccountModel> paymentAccounts;

  const CompanyProfileModel({
    required this.id,
    required this.name,
    required this.description,
    required this.contactPhone,
    required this.contactEmail,
    required this.address,
    required this.governorate,
    this.logo,
    this.coverImage,
    this.commissionType,
    this.commissionValue,
    this.monthlySubscriptionFee,
    this.subscriptionStatus,
    this.averageRating,
    this.reviewsCount,
    this.paymentAccounts = const [],
  });

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) {
    List<CompanyPaymentAccountModel> accounts = [];
    if (json['paymentAccounts'] is List) {
      accounts = (json['paymentAccounts'] as List)
          .map((e) => e is Map<String, dynamic>
              ? CompanyPaymentAccountModel.fromJson(e)
              : (e is Map
                  ? CompanyPaymentAccountModel.fromJson(
                      Map<String, dynamic>.from(e))
                  : null))
          .whereType<CompanyPaymentAccountModel>()
          .toList();
    }

    return CompanyProfileModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      contactPhone: json['contactPhone'] as String? ?? '',
      contactEmail: json['contactEmail'] as String? ?? '',
      address: json['address'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      logo: json['logo'] as String?,
      coverImage: json['coverImage'] as String?,
      commissionType: json['commissionType'] as String?,
      commissionValue: (json['commissionValue'] as num?)?.toDouble(),
      monthlySubscriptionFee:
          (json['monthlySubscriptionFee'] as num?)?.toDouble(),
      subscriptionStatus: json['subscriptionStatus'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewsCount: json['reviewsCount'] as int?,
      paymentAccounts: accounts,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'description': description,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'address': address,
      'governorate': governorate,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'address': address,
      'governorate': governorate,
      if (logo != null) 'logo': logo,
      if (coverImage != null) 'coverImage': coverImage,
      if (commissionType != null) 'commissionType': commissionType,
      if (commissionValue != null) 'commissionValue': commissionValue,
      if (monthlySubscriptionFee != null)
        'monthlySubscriptionFee': monthlySubscriptionFee,
      if (subscriptionStatus != null) 'subscriptionStatus': subscriptionStatus,
      if (averageRating != null) 'averageRating': averageRating,
      if (reviewsCount != null) 'reviewsCount': reviewsCount,
      'paymentAccounts': paymentAccounts.map((e) => e.toJson()).toList(),
    };
  }

  CompanyProfileModel copyWith({
    String? id,
    String? name,
    String? description,
    String? contactPhone,
    String? contactEmail,
    String? address,
    String? governorate,
    String? logo,
    String? coverImage,
    String? commissionType,
    double? commissionValue,
    double? monthlySubscriptionFee,
    String? subscriptionStatus,
    double? averageRating,
    int? reviewsCount,
    List<CompanyPaymentAccountModel>? paymentAccounts,
  }) {
    return CompanyProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      address: address ?? this.address,
      governorate: governorate ?? this.governorate,
      logo: logo ?? this.logo,
      coverImage: coverImage ?? this.coverImage,
      commissionType: commissionType ?? this.commissionType,
      commissionValue: commissionValue ?? this.commissionValue,
      monthlySubscriptionFee:
          monthlySubscriptionFee ?? this.monthlySubscriptionFee,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      averageRating: averageRating ?? this.averageRating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      paymentAccounts: paymentAccounts ?? this.paymentAccounts,
    );
  }
}
