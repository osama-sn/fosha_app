import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/admin/offers/data/datasources/offers_remote_data_source.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';

class OffersRepository {
  final OffersRemoteDataSource dataSource;

  OffersRepository({required this.dataSource});

  Future<Either<Failure, List<OfferModel>>> getCompanyOffers() async {
    try {
      final response = await dataSource.getCompanyOffers();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, OfferModel>> createOffer({
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
      final response = await dataSource.createOffer(
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
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, OfferModel>> updateOffer({
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
      final response = await dataSource.updateOffer(
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
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, void>> deleteOffer(String offerId) async {
    try {
      await dataSource.deleteOffer(offerId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }
}
