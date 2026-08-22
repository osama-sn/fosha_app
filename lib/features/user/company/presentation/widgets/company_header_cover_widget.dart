import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';

class CompanyHeaderCoverWidget extends StatelessWidget {
  final CompanyProfileModel? profile;

  const CompanyHeaderCoverWidget({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 160.h,
            child: profile?.coverImage != null && profile!.coverImage!.isNotEmpty
                ? AppNetworkImage(
                    imageUrl: profile!.coverImage!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppColors.primaryDark,
                    child: const Icon(
                      Icons.landscape,
                      color: Colors.white24,
                      size: 64,
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 90.r,
                height: 90.r,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: profile?.logo != null && profile!.logo!.isNotEmpty
                    ? ClipOval(
                        child: AppNetworkImage(
                          imageUrl: profile!.logo!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor:
                            AppColors.primaryLight.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.storefront,
                          color: AppColors.primaryDark,
                          size: 40.r,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
