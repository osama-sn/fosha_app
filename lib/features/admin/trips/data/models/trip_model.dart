import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';

class TripCategoryModel {
  final String id;
  final String nameEn;
  final String nameAr;
  final String slug;
  final String image;

  const TripCategoryModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.slug,
    required this.image,
  });

  factory TripCategoryModel.fromJson(Map<String, dynamic> json) {
    return TripCategoryModel(
      id: (json['_id'] ?? json['id']) as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'slug': slug,
      'image': image,
    };
  }
}

class TripActivityModel {
  final String id;
  final String time;
  final String title;
  final String description;
  final String location;
  final String image;

  const TripActivityModel({
    required this.id,
    required this.time,
    required this.title,
    required this.description,
    required this.location,
    required this.image,
  });

  factory TripActivityModel.fromJson(Map<String, dynamic> json) {
    return TripActivityModel(
      id: (json['_id'] ?? json['id']) as String? ?? '',
      time: json['time'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'time': time,
      'title': title,
      'description': description,
      'location': location,
      'image': image,
    };
  }
}

class TripDayModel {
  final String id;
  final int dayNumber;
  final String title;
  final List<TripActivityModel> activities;

  const TripDayModel({
    required this.id,
    required this.dayNumber,
    required this.title,
    required this.activities,
  });

  factory TripDayModel.fromJson(Map<String, dynamic> json) {
    return TripDayModel(
      id: (json['_id'] ?? json['id']) as String? ?? '',
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      activities:
          (json['activities'] as List<dynamic>?)
              ?.map(
                (e) => e is Map<String, dynamic>
                    ? TripActivityModel.fromJson(e)
                    : (e is Map
                          ? TripActivityModel.fromJson(
                              Map<String, dynamic>.from(e),
                            )
                          : null),
              )
              .whereType<TripActivityModel>()
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'dayNumber': dayNumber,
      'title': title,
      'activities': activities.map((e) => e.toJson()).toList(),
    };
  }
}

class TripModel {
  final String id;
  final String title;
  final String description;
  final String origin;
  final String destination;
  final double price;
  final int capacity;
  final int availableSeats;
  final String startDate;
  final String endDate;
  final TripCategoryModel? category;
  final String status;
  final bool createdBySystem;
  final bool isProtected;
  final String coverImage;
  final List<String> gallery;
  final List<String> included;
  final List<String> excluded;
  final String cancelPolicy;
  final double averageRating;
  final int reviewsCount;
  final List<TripDayModel> days;
  final String createdAt;
  final String updatedAt;
  final CompanyProfileModel? company;
  final String companyId;
  final String companyName;
  final String companyLogo;

  const TripModel({
    required this.id,
    required this.title,
    required this.description,
    required this.origin,
    required this.destination,
    required this.price,
    required this.capacity,
    required this.availableSeats,
    required this.startDate,
    required this.endDate,
    this.category,
    required this.status,
    required this.createdBySystem,
    required this.isProtected,
    required this.coverImage,
    required this.gallery,
    required this.included,
    required this.excluded,
    required this.cancelPolicy,
    required this.averageRating,
    required this.reviewsCount,
    required this.days,
    required this.createdAt,
    required this.updatedAt,
    this.company,
    this.companyId = '',
    this.companyName = '',
    this.companyLogo = '',
  });
  List<String> get galleryWithBaseUrl =>
      gallery.map((e) => ApiEndpoints.getImageUrl(e)).toList();
  factory TripModel.fromJson(Map<String, dynamic> json) {
    CompanyProfileModel? companyObj;
    String cId = '';
    String cName = '';
    String cLogo = '';

    if (json['company'] != null) {
      if (json['company'] is Map) {
        final cMap = Map<String, dynamic>.from(json['company'] as Map);
        companyObj = CompanyProfileModel.fromJson(cMap);
        cId = companyObj.id;
        cName = companyObj.name;
        cLogo = companyObj.logo ?? '';
      } else if (json['company'] is String) {
        cId = json['company'] as String;
      }
    }
    if (cId.isEmpty && json['companyId'] != null) {
      cId = json['companyId'].toString();
    }

    return TripModel(
      id: (json['_id'] ?? json['id']) as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      availableSeats: (json['availableSeats'] as num?)?.toInt() ?? 0,
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      category: json['category'] is Map<String, dynamic>
          ? TripCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : (json['category'] is Map
                ? TripCategoryModel.fromJson(
                    Map<String, dynamic>.from(json['category'] as Map),
                  )
                : (json['category'] is String
                      ? TripCategoryModel(
                          id: json['category'] as String,
                          nameEn: '',
                          nameAr: '',
                          slug: '',
                          image: '',
                        )
                      : null)),
      status: json['status'] as String? ?? 'published',
      createdBySystem: json['createdBySystem'] as bool? ?? false,
      isProtected: json['isProtected'] as bool? ?? false,
      coverImage: json['coverImage'] as String? ?? '',
      gallery:
          (json['gallery'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      included:
          (json['included'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      excluded:
          (json['excluded'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      cancelPolicy: json['cancelPolicy'] as String? ?? '',
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      days:
          (json['days'] as List<dynamic>?)
              ?.map(
                (e) => e is Map<String, dynamic>
                    ? TripDayModel.fromJson(e)
                    : (e is Map
                          ? TripDayModel.fromJson(Map<String, dynamic>.from(e))
                          : null),
              )
              .whereType<TripDayModel>()
              .toList() ??
          [],
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      company: companyObj,
      companyId: cId,
      companyName: cName,
      companyLogo: cLogo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'origin': origin,
      'destination': destination,
      'price': price,
      'capacity': capacity,
      'availableSeats': availableSeats,
      'startDate': startDate,
      'endDate': endDate,
      'category': category?.toJson(),
      'status': status,
      'createdBySystem': createdBySystem,
      'isProtected': isProtected,
      'coverImage': coverImage,
      'gallery': gallery,
      'included': included,
      'excluded': excluded,
      'cancelPolicy': cancelPolicy,
      'averageRating': averageRating,
      'reviewsCount': reviewsCount,
      'days': days.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  int get durationInDays {
    if (startDate.isEmpty || endDate.isEmpty) {
      return days.isNotEmpty ? days.length : 1;
    }
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      final diff = end.difference(start).inDays;
      return diff > 0 ? diff : (days.isNotEmpty ? days.length : 1);
    } catch (_) {
      return days.isNotEmpty ? days.length : 1;
    }
  }

  int get durationInNights {
    final d = durationInDays;
    return d > 1 ? d - 1 : 0;
  }

  String get durationText {
    final d = durationInDays;
    final n = durationInNights;
    if (n == 0) return '$d يوم';
    return '$d أيام - $n ليالي';
  }

  String get fullCoverImageUrl => ApiEndpoints.getImageUrl(coverImage);
}
