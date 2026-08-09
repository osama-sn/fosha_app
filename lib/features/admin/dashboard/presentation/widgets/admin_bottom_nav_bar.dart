import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const AdminBottomNavBar({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: Offset(0, -3.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Item 1: Home (الرئيسية)
          _buildNavItem(
            context,
            icon: Icons.home,
            label: AppStrings.navHome,
            isSelected: selectedIndex == 0,
            onTap: () {},
          ),

          // Item 2: Bookings (الحجوزات)
          _buildNavItem(
            context,
            icon: Icons.calendar_month_outlined,
            label: AppStrings.navBookings,
            isSelected: selectedIndex == 1,
            onTap: () => context.push(RouteNames.adminBookings),
          ),

          // Item 3: Center Action Button (+ إضافة رحلة)
          GestureDetector(
            onTap: () => context.push(RouteNames.addTrip),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryDark,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 26.r,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.adminAddTrip,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 9.sp,
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Item 4: Trips (الرحلات)
          _buildNavItem(
            context,
            icon: Icons.explore_outlined,
            label: AppStrings.adminTripsTitle,
            isSelected: selectedIndex == 3,
            onTap: () => context.push(RouteNames.adminTrips),
          ),

          // Item 5: Account (الحساب)
          _buildNavItem(
            context,
            icon: Icons.person_outline,
            label: AppStrings.profileTitle,
            isSelected: selectedIndex == 4,
            onTap: () => context.push(RouteNames.companyProfile),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? AppColors.primaryDark : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22.r),
          SizedBox(height: 3.h),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
