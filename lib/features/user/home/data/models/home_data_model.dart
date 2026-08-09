import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/categories/data/models/category_model.dart';

class HomeDataModel {
  final String userGovernorate;
  final List<TripModel> featuredTrips;
  final List<TripModel> governorateTrips;
  final List<CompanyProfileModel> featuredCompanies;
  final List<CategoryModel> categories;
  final List<OfferModel> offers;

  const HomeDataModel({
    required this.userGovernorate,
    required this.featuredTrips,
    required this.governorateTrips,
    required this.featuredCompanies,
    required this.categories,
    required this.offers,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      userGovernorate: json['userGovernorate'] as String? ?? '',
      featuredTrips: (json['featuredTrips'] as List<dynamic>?)
              ?.map(
                (e) => e is Map<String, dynamic>
                    ? TripModel.fromJson(e)
                    : (e is Map
                          ? TripModel.fromJson(Map<String, dynamic>.from(e))
                          : null),
              )
              .whereType<TripModel>()
              .toList() ??
          [],
      governorateTrips: (json['governorateTrips'] as List<dynamic>?)
              ?.map(
                (e) => e is Map<String, dynamic>
                    ? TripModel.fromJson(e)
                    : (e is Map
                          ? TripModel.fromJson(Map<String, dynamic>.from(e))
                          : null),
              )
              .whereType<TripModel>()
              .toList() ??
          [],
      featuredCompanies: (json['featuredCompanies'] as List<dynamic>?)
              ?.map(
                (e) => e is Map<String, dynamic>
                    ? CompanyProfileModel.fromJson(e)
                    : (e is Map
                          ? CompanyProfileModel.fromJson(
                              Map<String, dynamic>.from(e),
                            )
                          : null),
              )
              .whereType<CompanyProfileModel>()
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map(
                (e) => e is Map<String, dynamic>
                    ? CategoryModel.fromJson(e)
                    : (e is Map
                          ? CategoryModel.fromJson(
                              Map<String, dynamic>.from(e),
                            )
                          : null),
              )
              .whereType<CategoryModel>()
              .toList() ??
          [],
      offers: (json['offers'] as List<dynamic>?)
              ?.map(
                (e) => e is Map<String, dynamic>
                    ? OfferModel.fromJson(e)
                    : (e is Map
                          ? OfferModel.fromJson(Map<String, dynamic>.from(e))
                          : null),
              )
              .whereType<OfferModel>()
              .toList() ??
          [],
    );
  }
}
