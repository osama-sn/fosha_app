class ReviewUserModel {
  final String fullName;
  final String? profileImage;

  const ReviewUserModel({
    required this.fullName,
    this.profileImage,
  });

  factory ReviewUserModel.fromJson(Map<String, dynamic> json) {
    return ReviewUserModel(
      fullName: json['fullName'] as String? ?? json['name'] as String? ?? 'عميل',
      profileImage: json['profileImage'] as String? ?? json['avatar'] as String?,
    );
  }
}

class CompanyReviewModel {
  final String id;
  final ReviewUserModel user;
  final double rating;
  final String comment;
  final String? tripTitle;
  final String createdAt;

  const CompanyReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    this.tripTitle,
    required this.createdAt,
  });

  factory CompanyReviewModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>? ?? {};
    String? tTitle;
    if (json['trip'] != null) {
      if (json['trip'] is Map) {
        tTitle = json['trip']['title'] as String?;
      }
    }

    return CompanyReviewModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      user: ReviewUserModel.fromJson(userJson),
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      comment: json['comment'] as String? ?? json['review'] as String? ?? '',
      tripTitle: tTitle,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

class CompanyReviewsResponseModel {
  final double averageRating;
  final int totalReviews;
  final List<CompanyReviewModel> reviews;

  const CompanyReviewsResponseModel({
    required this.averageRating,
    required this.totalReviews,
    required this.reviews,
  });

  factory CompanyReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    final list = (data['reviews'] as List<dynamic>?)
            ?.map((e) => CompanyReviewModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final avg = (data['averageRating'] as num?)?.toDouble() ??
        (data['avgRating'] as num?)?.toDouble() ??
        0.0;
    final count = (data['totalReviews'] as int?) ??
        (data['reviewsCount'] as int?) ??
        list.length;

    return CompanyReviewsResponseModel(
      averageRating: avg,
      totalReviews: count,
      reviews: list,
    );
  }
}
