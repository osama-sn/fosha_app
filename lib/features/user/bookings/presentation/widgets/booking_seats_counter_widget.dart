import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class BookingSeatsCounterWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final int count;
  final ValueChanged<int> onChanged;

  const BookingSeatsCounterWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: count > 0 ? () => onChanged(count - 1) : null,
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: count > 0 ? AppColors.surface : AppColors.divider,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: count > 0 ? AppColors.border : Colors.transparent,
                    ),
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 16.r,
                    color: count > 0
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Text(
                '$count',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 14.w),
              InkWell(
                onTap: () => onChanged(count + 1),
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 16.r,
                    color: Colors.white,
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
