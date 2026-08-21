import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminFeaturesGrid extends StatelessWidget {
  const AdminFeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'title': 'قائمة المسافرين',
        'subtitle': 'المانفيست ونقاط التجمع',
        'icon': Icons.people_alt_outlined,
        'color': AppColors.primary,
        'route': RouteNames.adminPassengers,
      },
      {
        'title': 'المصروفات',
        'subtitle': 'تسجيل وإدارة المصروفات',
        'icon': Icons.receipt_long_outlined,
        'color': Colors.red,
        'route': RouteNames.adminExpenses,
      },
      {
        'title': 'التقارير المالية',
        'subtitle': 'الأرباح والمبيعات المفصلة',
        'icon': Icons.insert_chart_outlined,
        'color': Colors.indigo,
        'route': RouteNames.adminFinancialReport,
      },
      {
        'title': 'الشات والتواصل',
        'subtitle': 'المحادثات الحية مع العملاء',
        'icon': Icons.chat_bubble_outline,
        'color': Colors.teal,
        'route': RouteNames.adminChats,
      },
      {
        'title': 'التقييمات',
        'subtitle': 'تقييمات وآراء المسافرين',
        'icon': Icons.star_outline,
        'color': Colors.amber.shade800,
        'route': RouteNames.adminReviews,
      },
      {
        'title': 'قائمة العملاء',
        'subtitle': 'سجل بيانات وحجوزات العملاء',
        'icon': Icons.contacts_outlined,
        'color': Colors.purple,
        'route': RouteNames.adminCustomers,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.adminCompanyTools,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.35,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final f = features[index];
            final color = f['color'] as Color;
            return InkWell(
              onTap: () => context.push(f['route'] as String),
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.04),
                      blurRadius: 8.r,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(f['icon'] as IconData, color: color, size: 20.r),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      f['title'] as String,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      f['subtitle'] as String,
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
            );
          },
        ),
      ],
    );
  }
}
