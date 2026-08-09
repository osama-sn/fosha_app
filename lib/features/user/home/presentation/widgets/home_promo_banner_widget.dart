import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';

class HomePromoBannerWidget extends StatelessWidget {
  final List<OfferModel> offers;

  const HomePromoBannerWidget({super.key, this.offers = const []});

  @override
  Widget build(BuildContext context) {
    final hasOffer = offers.isNotEmpty;
    final firstOffer = hasOffer ? offers.first : null;

    final title = hasOffer && firstOffer!.titleAr.isNotEmpty
        ? firstOffer.titleAr
        : AppStrings.homeDiscountBanner;

    final subtitle = hasOffer && firstOffer!.discountPercentage > 0
        ? 'خصم ${firstOffer.discountPercentage.toStringAsFixed(0)}% عند استخدام كود ${firstOffer.promoCode}'
        : AppStrings.homeDiscountSubtitle;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.1),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        padding: EdgeInsets.all(AppSizes.p16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSizes.p4.verticalSpace,
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSizes.p12.verticalSpace,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryDark,
                      minimumSize: Size(0, 32.h),
                    ),
                    onPressed: () {},
                    child: Text(
                      AppStrings.bookNow,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.discount,
              color: AppColors.secondary.withValues(alpha: 0.25),
              size: 54.sp,
            ),
          ],
        ),
      ),
    );
  }
}
