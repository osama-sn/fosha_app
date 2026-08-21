class ReviewUserModel {
  final String fullName;
  final String? profileImage;

  const ReviewUserModel({
    required this.fullName,
    this.profileImage,
  });

  factory ReviewUserModel.fromJson(Map<String, dynamic> json) {
    return ReviewUserModel(
      fullName: json['fullName'] as String? ?? json['name'] as String? ?? 'مستخدم',
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
    final userJson = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : <String, dynamic>{
            'fullName': json['userName'] ?? json['customerName'] ?? 'مستخدم',
            'profileImage': json['userImage'] ?? json['avatar'],
          };

    String? tTitle;
    if (json['trip'] != null && json['trip'] is Map) {
      tTitle = json['trip']['title'] as String?;
    } else if (json['tripTitle'] != null) {
      tTitle = json['tripTitle'] as String?;
    }

    return CompanyReviewModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      user: ReviewUserModel.fromJson(userJson),
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      comment: json['comment'] as String? ??
          json['review'] as String? ??
          'خدمة ممتازة ورحلة منظمة جداً',
      tripTitle: tTitle,
      createdAt: json['createdAt'] as String? ?? 'مؤخراً',
    );
  }
}
