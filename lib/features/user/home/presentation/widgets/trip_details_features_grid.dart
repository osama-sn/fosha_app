import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';

class TripDetailsFeaturesGrid extends StatelessWidget {
  final TripModel trip;

  const TripDetailsFeaturesGrid({super.key, required this.trip});

  String _formatStartDate(String startDateStr) {
    if (startDateStr.isEmpty) return 'تاريخ محدد';
    try {
      final date = DateTime.parse(startDateStr);
      final months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];
      return '${date.day} ${months[date.month - 1]}';
    } catch (_) {
      return startDateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatStartDate(trip.startDate);

    // Dynamic places count from activities/locations
    final placesCount = trip.days.isNotEmpty
        ? trip.days
              .expand((d) => d.activities)
              .where(
                (a) =>
                    a.location.trim().isNotEmpty || a.title.trim().isNotEmpty,
              )
              .length
        : 0;
    final placesTitle = placesCount > 0 ? '$placesCount مكان' : 'حسب البرنامج';

    // Dynamic nights count from duration
    final nightsCount = trip.durationInNights;
    final nightsTitle = nightsCount > 0 ? '$nightsCount ليالي' : 'بدون إقامة';

    return Row(
      children: [
        Expanded(
          child: QuickInfoCard(
            icon: Icons.calendar_month_outlined,
            title: formattedDate,
            subtitle: 'تاريخ البداية',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: QuickInfoCard(
            icon: Icons.location_on_outlined,
            title: placesTitle,
            subtitle: 'عدد الأماكن',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: QuickInfoCard(
            icon: Icons.hotel_outlined,
            title: nightsTitle,
            subtitle: 'الإقامة',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: QuickInfoCard(
            icon: Icons.access_time_outlined,
            title: trip.durationText.isNotEmpty ? trip.durationText : '1 يوم',
            subtitle: 'المدة',
          ),
        ),
      ],
    );
  }
}

class QuickInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const QuickInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primaryDark, size: 22.sp),
          AppSizes.p6.verticalSpace,
          Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 11.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSizes.p2.verticalSpace,
          Text(
            subtitle,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textHint,
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
