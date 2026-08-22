import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class UserBookingStatusBadgeWidget extends StatelessWidget {
  final String status;

  const UserBookingStatusBadgeWidget({super.key, required this.status});

  Color _getStatusColor(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
      case 'مؤكدة':
        return Colors.green;
      case 'pending':
      case 'قيد الانتظار':
        return Colors.orange;
      case 'rejected':
      case 'مرفوضة':
        return Colors.red;
      case 'cancelled':
      case 'ملغاة':
        return Colors.grey;
      default:
        return AppColors.primaryDark;
    }
  }

  String _getStatusText(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
        return AppStrings.bookingStatusConfirmed;
      case 'pending':
        return AppStrings.bookingStatusPending;
      case 'rejected':
        return AppStrings.bookingStatusRejected;
      case 'cancelled':
        return AppStrings.bookingStatusCancelled;
      default:
        return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
