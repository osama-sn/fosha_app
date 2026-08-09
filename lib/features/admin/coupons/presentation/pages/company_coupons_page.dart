import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/coupons/data/models/coupon_model.dart';
import 'package:fosha_app/features/admin/coupons/presentation/cubit/coupons_cubit.dart';
import 'package:fosha_app/features/admin/coupons/presentation/cubit/coupons_state.dart';
import 'package:fosha_app/features/admin/coupons/presentation/widgets/add_coupon_bottom_sheet.dart';
import 'package:fosha_app/features/admin/coupons/presentation/widgets/coupon_card.dart';

class CompanyCouponsPage extends StatelessWidget {
  const CompanyCouponsPage({super.key});

  void _openAddCouponBottomSheet(BuildContext context) {
    final couponsCubit = context.read<CouponsCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: couponsCubit,
          child: const AddCouponBottomSheet(),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, CouponModel coupon) {
    final couponsCubit = context.read<CouponsCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف الكوبون'),
        content: Text('هل أنت تأكد من رغبتك في حذف الكوبون "${coupon.code}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              couponsCubit.deleteCoupon(coupon.id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CouponsCubit>(
      create: (context) => getIt<CouponsCubit>()..fetchCompanyCoupons(),
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
            'كوبونات الخصم للشركة',
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
              onPressed: () => _openAddCouponBottomSheet(context),
              icon: const Icon(Icons.confirmation_number_outlined,
                  color: Colors.white),
              label: Text(
                'كوبون جديد',
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        body: BlocConsumer<CouponsCubit, CouponsState>(
          listener: (context, state) {
            if (state is CouponsActionSuccess) {
              AppSnackbar.showSuccess(context: context, message: state.message);
            } else if (state is CouponsFailure) {
              AppSnackbar.showError(context: context, message: state.error);
            }
          },
          builder: (context, state) {
            if (state is CouponsLoading) {
              return const AppLoading();
            }

            List<CouponModel> coupons = [];
            if (state is CouponsLoaded) {
              coupons = state.coupons;
            } else if (state is CouponsSubmitting) {
              coupons = state.currentCoupons;
            } else if (state is CouponsActionSuccess) {
              coupons = state.coupons;
            }

            if (coupons.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.p20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.confirmation_number_outlined,
                          size: 64.r, color: AppColors.textHint),
                      AppSizes.p16.verticalSpace,
                      Text(
                        'لا توجد كوبونات خصم حالية',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p8.verticalSpace,
                      Text(
                        'يمكنك إنشاء أكواد تخفيض خاصة بشركتك فقط وتوزيعها على المسافرين',
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
              onRefresh: () => context.read<CouponsCubit>().fetchCompanyCoupons(),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.p16,
                  vertical: AppSizes.p16,
                ),
                itemCount: coupons.length,
                separatorBuilder: (context, index) => AppSizes.p16.verticalSpace,
                itemBuilder: (context, index) {
                  final coupon = coupons[index];
                  return CouponCard(
                    coupon: coupon,
                    onDelete: () => _confirmDelete(context, coupon),
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
