import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/passengers/data/models/passenger_model.dart';

class AdminPassengerCard extends StatelessWidget {
  final PassengerModel passenger;

  const AdminPassengerCard({
    super.key,
    required this.passenger,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(
                    passenger.user.fullName.isNotEmpty
                        ? passenger.user.fullName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passenger.user.fullName,
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        passenger.user.phone,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${passenger.numberOfSeats} ${AppStrings.adminSeatsCount}',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 20.h),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: AppColors.primary),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    '${AppStrings.adminPickupPointLabel} ${passenger.pickupPoint.isNotEmpty ? passenger.pickupPoint : AppStrings.adminUnspecified}',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                if (passenger.pickupTime.isNotEmpty) ...[
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    passenger.pickupTime,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
            if (passenger.notes.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Row(
                children: [
                  const Icon(Icons.note_alt_outlined,
                      size: 16, color: Colors.orange),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      '${AppStrings.adminNotesPrefix}: ${passenger.notes}',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: Colors.orange.shade800),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
