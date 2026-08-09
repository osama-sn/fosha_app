import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';
import 'package:fosha_app/features/admin/offers/data/repositories/offers_repository.dart';
import 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final OffersRepository repository;

  OffersCubit({required this.repository}) : super(OffersInitial());

  List<OfferModel> _currentOffers = [];

  Future<void> fetchCompanyOffers() async {
    emit(OffersLoading());
    try {
      final offers = await repository.getCompanyOffers();
      _currentOffers = offers;
      emit(OffersLoaded(offers: offers));
    } catch (e) {
      emit(OffersFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
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
    try {
      await repository.createOffer(
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
      final updatedList = await repository.getCompanyOffers();
      _currentOffers = updatedList;
      emit(OffersActionSuccess(
        offers: updatedList,
        message: 'تم إضافة العرض الترويجي بنجاح',
      ));
    } catch (e) {
      emit(OffersFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
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
    try {
      await repository.updateOffer(
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
      final updatedList = await repository.getCompanyOffers();
      _currentOffers = updatedList;
      emit(OffersActionSuccess(
        offers: updatedList,
        message: 'تم تعديل العرض بنجاح',
      ));
    } catch (e) {
      emit(OffersFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deleteOffer(String offerId) async {
    emit(OffersSubmitting(currentOffers: _currentOffers));
    try {
      await repository.deleteOffer(offerId);
      final updatedList = await repository.getCompanyOffers();
      _currentOffers = updatedList;
      emit(OffersActionSuccess(
        offers: updatedList,
        message: 'تم حذف العرض بنجاح',
      ));
    } catch (e) {
      emit(OffersFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
