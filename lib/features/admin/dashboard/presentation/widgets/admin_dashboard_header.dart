import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminDashboardHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final String companyName;
  final VoidCallback onLogout;

  const AdminDashboardHeader({
    super.key,
    required this.companyName,
    required this.onLogout,
  });

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.primaryDark),
        onPressed: () {},
      ),
      centerTitle: true,
      title: Column(
        children: [
          Text(
            AppStrings.adminDashboardTitle,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          Text(
            companyName.isNotEmpty ? companyName : '',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_none_outlined,
                color: AppColors.primaryDark,
                size: 24.r,
              ),
              onPressed: () {},
            ),
            Positioned(
              top: 14.h,
              right: 14.w,
              child: Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          onSelected: (value) {
            if (value == 'company_profile') {
              context.push(RouteNames.companyProfile);
            } else if (value == 'company_offers') {
              context.push(RouteNames.companyOffers);
            } else if (value == 'company_coupons') {
              context.push(RouteNames.companyCoupons);
            } else if (value == 'logout') {
              onLogout();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'company_profile',
              child: Row(
                children: [
                  const Icon(Icons.storefront, color: AppColors.primaryDark),
                  const SizedBox(width: 8),
                  Text(AppStrings.companyProfileEditTitle),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'company_offers',
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer_outlined,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 8),
                  Text(AppStrings.promotionalOffers),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'company_coupons',
              child: Row(
                children: [
                  const Icon(
                    Icons.confirmation_number_outlined,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 8),
                  Text(AppStrings.discountCoupons),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout, color: AppColors.error),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.profileLogout,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
