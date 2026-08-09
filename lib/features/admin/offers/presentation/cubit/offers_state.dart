import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';

abstract class OffersState extends Equatable {
  const OffersState();

  @override
  List<Object?> get props => [];
}

class OffersInitial extends OffersState {}

class OffersLoading extends OffersState {}

class OffersLoaded extends OffersState {
  final List<OfferModel> offers;

  const OffersLoaded({required this.offers});

  @override
  List<Object?> get props => [offers];
}

class OffersSubmitting extends OffersState {
  final List<OfferModel> currentOffers;

  const OffersSubmitting({required this.currentOffers});

  @override
  List<Object?> get props => [currentOffers];
}

class OffersActionSuccess extends OffersState {
  final List<OfferModel> offers;
  final String message;

  const OffersActionSuccess({
    required this.offers,
    required this.message,
  });

  @override
  List<Object?> get props => [offers, message];
}

class OffersFailure extends OffersState {
  final String error;

  const OffersFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
