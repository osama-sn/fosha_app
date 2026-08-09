import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';
import 'package:intl/intl.dart';

class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OfferCard({
    super.key,
    required this.offer,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Header with Badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: SizedBox(
                  height: 140.h,
                  width: double.infinity,
                  child: AppNetworkImage(
                    imageUrl: offer.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Discount Tag
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.p12,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.2),
                        blurRadius: 4.r,
                      ),
                    ],
                  ),
                  child: Text(
                    'خصم ${offer.discountPercentage.toStringAsFixed(0)}%',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Promo Code Badge
              if (offer.promoCode.isNotEmpty)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.p10,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      offer.promoCode,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(AppSizes.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.titleAr.isNotEmpty ? offer.titleAr : offer.titleEn,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (offer.descriptionAr.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    offer.descriptionAr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
                SizedBox(height: 12.h),

                // Trip association badge
                if (offer.tripTitle != null && offer.tripTitle!.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.directions_bus,
                        size: 14.r,
                        color: AppColors.primaryDark,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${AppStrings.tripCategoryLabel}: ${offer.tripTitle}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                ],

                // Dates info
                if (offer.startDate != null || offer.endDate != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14.r,
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${AppStrings.validity}: ${offer.startDate != null ? dateFormat.format(offer.startDate!) : 'الآن'} - ${offer.endDate != null ? dateFormat.format(offer.endDate!) : AppStrings.unrestricted}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],

                const Divider(color: AppColors.border, height: 1),
                SizedBox(height: 8.h),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 18.r,
                        color: AppColors.primaryDark,
                      ),
                      label: Text(
                        AppStrings.adminEditTrip,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18.r,
                        color: AppColors.error,
                      ),
                      label: Text(
                        AppStrings.adminDeleteTrip,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
