import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';
import 'package:fosha_app/features/admin/offers/data/repositories/offers_repository.dart';
import 'offers_state.dart';
export 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final OffersRepository repository;

  OffersCubit({required this.repository}) : super(OffersInitial());

  List<OfferModel> _currentOffers = [];

  Future<void> fetchCompanyOffers() async {
    emit(OffersLoading());
    final result = await repository.getCompanyOffers();

    result.fold(
      (failure) => emit(OffersFailure(error: failure.message)),
      (offers) {
        _currentOffers = offers;
        emit(OffersLoaded(offers: offers));
      },
    );
  }

  Future<void> createOffer({
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
    emit(OffersSubmitting(currentOffers: _currentOffers));
    final createResult = await repository.createOffer(
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

    await createResult.fold(
      (failure) async => emit(OffersFailure(error: failure.message)),
      (_) async {
        final fetchResult = await repository.getCompanyOffers();
        fetchResult.fold(
          (failure) => emit(OffersFailure(error: failure.message)),
          (updatedList) {
            _currentOffers = updatedList;
            emit(OffersActionSuccess(
              offers: updatedList,
              message: AppStrings.adminOfferCreatedSuccess,
            ));
          },
        );
      },
    );
  }

  Future<void> updateOffer({
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
    emit(OffersSubmitting(currentOffers: _currentOffers));
    final updateResult = await repository.updateOffer(
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

    await updateResult.fold(
      (failure) async => emit(OffersFailure(error: failure.message)),
      (_) async {
        final fetchResult = await repository.getCompanyOffers();
        fetchResult.fold(
          (failure) => emit(OffersFailure(error: failure.message)),
          (updatedList) {
            _currentOffers = updatedList;
            emit(OffersActionSuccess(
              offers: updatedList,
              message: AppStrings.adminOfferUpdatedSuccess,
            ));
          },
        );
      },
    );
  }

  Future<void> deleteOffer(String offerId) async {
    emit(OffersSubmitting(currentOffers: _currentOffers));
    final deleteResult = await repository.deleteOffer(offerId);

    await deleteResult.fold(
      (failure) async => emit(OffersFailure(error: failure.message)),
      (_) async {
        final fetchResult = await repository.getCompanyOffers();
        fetchResult.fold(
          (failure) => emit(OffersFailure(error: failure.message)),
          (updatedList) {
            _currentOffers = updatedList;
            emit(OffersActionSuccess(
              offers: updatedList,
              message: AppStrings.adminOfferDeletedSuccess,
            ));
          },
        );
      },
    );
  }
}
