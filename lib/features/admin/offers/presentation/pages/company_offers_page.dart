import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';
import 'package:fosha_app/features/admin/offers/presentation/cubit/offers_cubit.dart';
import 'package:fosha_app/features/admin/offers/presentation/cubit/offers_state.dart';
import 'package:fosha_app/features/admin/offers/presentation/widgets/add_edit_offer_bottom_sheet.dart';
import 'package:fosha_app/features/admin/offers/presentation/widgets/offer_card.dart';

class CompanyOffersPage extends StatelessWidget {
  const CompanyOffersPage({super.key});

  void _openAddEditBottomSheet(BuildContext context, {OfferModel? offerToEdit}) {
    final offersCubit = context.read<OffersCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: offersCubit,
          child: AddEditOfferBottomSheet(offerToEdit: offerToEdit),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, OfferModel offer) {
    final offersCubit = context.read<OffersCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف العرض'),
        content: Text('هل أنت تأكد من رغبتك في حذف العرض "${offer.titleAr}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              offersCubit.deleteOffer(offer.id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OffersCubit>(
      create: (context) => getIt<OffersCubit>()..fetchCompanyOffers(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'عروض الشركة الترويجية',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton.extended(
              backgroundColor: AppColors.primaryDark,
              onPressed: () => _openAddEditBottomSheet(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'عرض جديد',
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        body: BlocConsumer<OffersCubit, OffersState>(
          listener: (context, state) {
            if (state is OffersActionSuccess) {
              AppSnackbar.showSuccess(context: context, message: state.message);
            } else if (state is OffersFailure) {
              AppSnackbar.showError(context: context, message: state.error);
            }
          },
          builder: (context, state) {
            if (state is OffersLoading) {
              return const AppLoading();
            }

            List<OfferModel> offers = [];
            if (state is OffersLoaded) {
              offers = state.offers;
            } else if (state is OffersSubmitting) {
              offers = state.currentOffers;
            } else if (state is OffersActionSuccess) {
              offers = state.offers;
            }

            if (offers.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.p20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_offer_outlined,
                          size: 64.r, color: AppColors.textHint),
                      AppSizes.p16.verticalSpace,
                      Text(
                        'لا توجد عروض ترويجية حالية',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p8.verticalSpace,
                      Text(
                        'يمكنك إضافة عروض ترويجية وتخفيضات لجذب عملاء جدد',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<OffersCubit>().fetchCompanyOffers(),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.p16,
                  vertical: AppSizes.p16,
                ),
                itemCount: offers.length,
                separatorBuilder: (context, index) => AppSizes.p16.verticalSpace,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return OfferCard(
                    offer: offer,
                    onEdit: () => _openAddEditBottomSheet(context, offerToEdit: offer),
                    onDelete: () => _confirmDelete(context, offer),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
