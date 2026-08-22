import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminPassengersSummaryBar extends StatelessWidget {
  final int passengersCount;
  final int totalSeatsBooked;
  final int capacity;

  const AdminPassengersSummaryBar({
    super.key,
    required this.passengersCount,
    required this.totalSeatsBooked,
    required this.capacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            AppStrings.adminPassengersCount,
            '$passengersCount ${AppStrings.adminPersonUnit}',
          ),
          _buildStatItem(
            AppStrings.adminCurrentSeats,
            '$totalSeatsBooked ${AppStrings.adminSeatUnit}',
          ),
          _buildStatItem(
            AppStrings.adminTripCapacity,
            '$capacity ${AppStrings.adminSeatUnit}',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}
