import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fosha_app/features/admin/offers/data/datasources/offers_remote_data_source.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';

class OffersRepository {
  final OffersRemoteDataSource dataSource;

  OffersRepository({required this.dataSource});

  Future<List<OfferModel>> getCompanyOffers() async {
    try {
      return await dataSource.getCompanyOffers();
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : 'فشل في جلب العروض';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

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
    try {
      return await dataSource.createOffer(
        titleAr: titleAr,
        titleEn: titleEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        discountPercentage: discountPercentage,
        promoCode: promoCode,
        tripId: tripId,
        startDate: startDate,
        endDate: endDate,
        priority: priority,
        imageFile: imageFile,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : 'فشل في إنشاء العرض';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

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
    try {
      return await dataSource.updateOffer(
        offerId: offerId,
        titleAr: titleAr,
        titleEn: titleEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        discountPercentage: discountPercentage,
        promoCode: promoCode,
        tripId: tripId,
        startDate: startDate,
        endDate: endDate,
        priority: priority,
        imageFile: imageFile,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : 'فشل في تعديل العرض';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deleteOffer(String offerId) async {
    try {
      await dataSource.deleteOffer(offerId);
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : 'فشل في حذف العرض';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
