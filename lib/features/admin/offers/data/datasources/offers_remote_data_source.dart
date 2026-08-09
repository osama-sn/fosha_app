import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';

abstract class OffersRemoteDataSource {
  Future<List<OfferModel>> getCompanyOffers();
  Future<OfferModel> createOffer({
    required String titleAr,
    required String titleEn,
    required String descriptionAr,
    required String descriptionEn,
    required double discountPercentage,
    required String promoCode,
    String? tripId,
    DateTime? startDate,
    DateTime? endDate,
    int priority = 0,
    File? imageFile,
  });
  Future<OfferModel> updateOffer({
    required String offerId,
    required String titleAr,
    required String titleEn,
    required String descriptionAr,
    required String descriptionEn,
    required double discountPercentage,
    required String promoCode,
    String? tripId,
    DateTime? startDate,
    DateTime? endDate,
    int priority = 0,
    File? imageFile,
  });
  Future<void> deleteOffer(String offerId);
}

class OffersRemoteDataSourceImpl implements OffersRemoteDataSource {
  final DioClient _dioClient;

  OffersRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<OfferModel>> getCompanyOffers() async {
    final response = await _dioClient.dio.get('/offers/admin/all');
    final responseData = response.data;
    List dynamicList = [];

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is List) {
        dynamicList = responseData['data'] as List;
      } else if (responseData['data'] is Map &&
          responseData['data']['offers'] is List) {
        dynamicList = responseData['data']['offers'] as List;
      }
    } else if (responseData is List) {
      dynamicList = responseData;
    }

    return dynamicList
        .map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OfferModel> createOffer({
    required String titleAr,
    required String titleEn,
    required String descriptionAr,
    required String descriptionEn,
    required double discountPercentage,
    required String promoCode,
    String? tripId,
    DateTime? startDate,
    DateTime? endDate,
    int priority = 0,
    File? imageFile,
  }) async {
    final formDataMap = <String, dynamic>{
      'titleAr': titleAr,
      'titleEn': titleEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'discountPercentage': discountPercentage,
      'promoCode': promoCode,
      'priority': priority,
      if (tripId != null && tripId.isNotEmpty) 'trip': tripId,
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
    };

    if (imageFile != null) {
      formDataMap['image'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(formDataMap);

    final response = await _dioClient.dio.post(
      '/offers',
      data: formData,
    );

    final responseData = response.data;
    Map<String, dynamic> offerJson;
    if (responseData is Map<String, dynamic> && responseData['data'] != null) {
      offerJson = responseData['data'] is Map
          ? responseData['data'] as Map<String, dynamic>
          : responseData;
    } else {
      offerJson = responseData as Map<String, dynamic>;
    }

    return OfferModel.fromJson(offerJson);
  }

  @override
  Future<OfferModel> updateOffer({
    required String offerId,
    required String titleAr,
    required String titleEn,
    required String descriptionAr,
    required String descriptionEn,
    required double discountPercentage,
    required String promoCode,
    String? tripId,
    DateTime? startDate,
    DateTime? endDate,
    int priority = 0,
    File? imageFile,
  }) async {
    final formDataMap = <String, dynamic>{
      'titleAr': titleAr,
      'titleEn': titleEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'discountPercentage': discountPercentage,
      'promoCode': promoCode,
      'priority': priority,
      if (tripId != null && tripId.isNotEmpty) 'trip': tripId,
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
    };

    if (imageFile != null) {
      formDataMap['image'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(formDataMap);

    final response = await _dioClient.dio.put(
      '/offers/$offerId',
      data: formData,
    );

    final responseData = response.data;
    Map<String, dynamic> offerJson;
    if (responseData is Map<String, dynamic> && responseData['data'] != null) {
      offerJson = responseData['data'] is Map
          ? responseData['data'] as Map<String, dynamic>
          : responseData;
    } else {
      offerJson = responseData as Map<String, dynamic>;
    }

    return OfferModel.fromJson(offerJson);
  }

  @override
  Future<void> deleteOffer(String offerId) async {
    await _dioClient.dio.delete('/offers/$offerId');
  }
}
