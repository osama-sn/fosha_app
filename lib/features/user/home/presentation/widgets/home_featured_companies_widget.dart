import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';

class HomeFeaturedCompaniesWidget extends StatelessWidget {
  final List<CompanyProfileModel> companies;

  const HomeFeaturedCompaniesWidget({super.key, this.companies = const []});

  @override
  Widget build(BuildContext context) {
    if (companies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'شركات سياحية مميزة ⭐',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        AppSizes.p12.verticalSpace,
        SizedBox(
          height: 90.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
            scrollDirection: Axis.horizontal,
            itemCount: companies.length,
            separatorBuilder: (context, index) => AppSizes.p12.horizontalSpace,
            itemBuilder: (context, index) {
              final company = companies[index];
              return GestureDetector(
                onTap: () {
                  context.push(
                    RouteNames.companyDetails,
                    extra: company.id,
                  );
                },
                child: Container(
                  width: 200.w,
                  padding: EdgeInsets.all(AppSizes.p10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.04),
                        blurRadius: 8.r,
                        offset: Offset(0, 3.h),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor:
                            AppColors.primaryLight.withValues(alpha: 0.15),
                        child: company.logo != null && company.logo!.isNotEmpty
                            ? ClipOval(
                                child: AppNetworkImage(
                                  imageUrl: company.logo!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.storefront,
                                color: AppColors.primaryDark,
                                size: 22.r,
                              ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              company.name,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              company.governorate.isNotEmpty
                                  ? company.governorate
                                  : company.address,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
