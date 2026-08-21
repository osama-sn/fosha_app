import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/admin/company_profile/data/repositories/company_profile_repository.dart';

class TripCompanyCard extends StatefulWidget {
  final CompanyProfileModel? company;
  final String? companyId;
  final String? companyName;
  final String? companyLogo;
  final double? averageRating;
  final int? reviewsCount;

  const TripCompanyCard({
    super.key,
    this.company,
    this.companyId,
    this.companyName,
    this.companyLogo,
    this.averageRating,
    this.reviewsCount,
  });

  @override
  State<TripCompanyCard> createState() => _TripCompanyCardState();
}

class _TripCompanyCardState extends State<TripCompanyCard> {
  CompanyProfileModel? _fetchedCompany;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAndFetchCompany();
  }

  @override
  void didUpdateWidget(covariant TripCompanyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.companyId != widget.companyId ||
        oldWidget.company != widget.company) {
      _checkAndFetchCompany();
    }
  }

  Future<void> _checkAndFetchCompany() async {
    final effectiveId = widget.company?.id ?? widget.companyId ?? '';
    final hasName = (widget.company?.name.isNotEmpty == true) ||
        (widget.companyName?.isNotEmpty == true);

    if (effectiveId.isNotEmpty && !hasName) {
      setState(() => _isLoading = true);
      try {
        final repository = getIt<CompanyProfileRepository>();
        final result = await repository.getCompanyProfile(effectiveId);
        result.fold(
          (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          (fetched) {
            if (mounted) {
              setState(() {
                _fetchedCompany = fetched;
                _isLoading = false;
              });
            }
          },
        );
      } catch (_) {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 100.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
        ),
        child: const AppLoading(),
      );
    }

    final companyObj = widget.company ?? _fetchedCompany;
    final effectiveId = companyObj?.id ?? widget.companyId ?? '';
    final name = companyObj?.name ?? widget.companyName ?? '';
    final logo = companyObj?.logo ?? widget.companyLogo ?? '';
    final rating = companyObj?.averageRating ?? widget.averageRating ?? 4.5;
    final count = companyObj?.reviewsCount ?? widget.reviewsCount ?? 0;

    if (effectiveId.isEmpty && name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات الشركة',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          AppSizes.p12.verticalSpace,
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.15),
                child: logo.isNotEmpty
                    ? ClipOval(
                        child: AppNetworkImage(
                          imageUrl: logo,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.storefront,
                        color: AppColors.primaryDark,
                        size: 24.r,
                      ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name.isNotEmpty ? name : 'شركة تنظيم رحلات',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.verified,
                          color: AppColors.primary,
                          size: 16.r,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.secondary,
                          size: 14.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          rating.toStringAsFixed(1),
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (count > 0) ...[
                          SizedBox(width: 2.w),
                          Text(
                            '($count)',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  if (effectiveId.isNotEmpty) {
                    context.push(
                      RouteNames.companyDetails,
                      extra: effectiveId,
                    );
                  }
                },
                child: Text(
                  'عرض الملف',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
