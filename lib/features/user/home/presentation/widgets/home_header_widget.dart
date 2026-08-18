import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_governorates.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/user/auth/data/models/user_model.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_states.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String currentGovernorate;
  final ValueChanged<String>? onGovernorateChanged;

  const HomeHeaderWidget({
    super.key,
    this.currentGovernorate = 'المنيا',
    this.onGovernorateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.p16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  UserModel? user;
                  if (authState is AuthSuccess) {
                    user = authState.user;
                  }
                  final profileImgUrl =
                      ApiEndpoints.getImageUrl(user?.profileImage);
                  final hasImage = profileImgUrl.isNotEmpty &&
                      (profileImgUrl.startsWith('http://') ||
                          profileImgUrl.startsWith('https://'));

                  return CircleAvatar(
                    radius: 22.r,
                    backgroundColor:
                        AppColors.primaryLight.withValues(alpha: 0.2),
                    backgroundImage: hasImage
                        ? NetworkImage(profileImgUrl) as ImageProvider
                        : null,
                    child: !hasImage
                        ? Icon(
                            Icons.person_outline,
                            color: AppColors.primaryDark,
                            size: 22.sp,
                          )
                        : null,
                  );
                },
              ),
              AppSizes.p12.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.homeTitle,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14.r,
                        color: AppColors.secondary,
                      ),
                      SizedBox(width: 4.w),
                      PopupMenuButton<String>(
                        onSelected: (gov) {
                          if (onGovernorateChanged != null) {
                            onGovernorateChanged!(gov);
                          }
                        },
                        itemBuilder: (context) {
                          return AppGovernorates.arabicNames.map((gov) {
                            return PopupMenuItem<String>(
                              value: gov,
                              child: Text(
                                gov,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: gov == currentGovernorate
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: gov == currentGovernorate
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        child: Row(
                          children: [
                            Text(
                              currentGovernorate.isNotEmpty
                                  ? currentGovernorate
                                  : 'المنيا',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 16.r,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
              color: AppColors.surface,
            ),
            child: Icon(
              Icons.notifications_none,
              color: AppColors.primaryDark,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
