import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/user_bookings_cubit.dart';

class UserBookingDetailsPage extends StatelessWidget {
  final BookingModel booking;

  const UserBookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBookingsCubit>(
      create: (context) => getIt<UserBookingsCubit>(),
      child: _UserBookingDetailsBody(booking: booking),
    );
  }
}

class _UserBookingDetailsBody extends StatelessWidget {
  final BookingModel booking;

  const _UserBookingDetailsBody({required this.booking});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
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

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
        return 'مؤكدة';
      case 'pending':
        return 'قيد الانتظار';
      case 'rejected':
        return 'مرفوضة';
      case 'cancelled':
        return 'ملغاة';
      default:
        return status;
    }
  }

  String _getBookingDuration(BookingModel booking) {
    if (booking.trip != null &&
        booking.trip!.startDate.isNotEmpty &&
        booking.trip!.endDate.isNotEmpty) {
      try {
        final start = DateTime.parse(booking.trip!.startDate);
        final end = DateTime.parse(booking.trip!.endDate);
        final days = end.difference(start).inDays;
        if (days <= 0) return '1 يوم';
        final nights = days > 1 ? days - 1 : 0;
        if (nights == 0) return '$days يوم';
        return '$days أيام - $nights ليالي';
      } catch (_) {}
    }
    return '1 يوم';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(booking.status);
    final statusText = _getStatusText(booking.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          'تفاصيل الحجز',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10.r,
              offset: Offset(0, -4.h),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('إلغاء الحجز'),
                        content: const Text(
                          'هل أنت تأكد من رغبتك في إلغاء هذا الحجز؟',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.read<UserBookingsCubit>().cancelBooking(
                                booking.id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم إلغاء الحجز بنجاح'),
                                ),
                              );
                              context.pop();
                            },
                            child: const Text(
                              'تأكيد الإلغاء',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'إلغاء الحجز',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: Text(
                    'تواصل مع الشركة',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover Image
            SizedBox(
              height: 200.h,
              width: double.infinity,
              child: AppNetworkImage(
                imageUrl: booking.tripCoverImage,
                fit: BoxFit.cover,
              ),
            ),
            AppSizes.p16.verticalSpace,

            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Status Chip + Ref code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          statusText,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '#FSH-${booking.id.substring(booking.id.length > 8 ? booking.id.length - 8 : 0).toUpperCase()}',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: booking.id),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم نسخ رقم الحجز'),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.copy,
                              size: 14.r,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AppSizes.p8.verticalSpace,
                  Text(
                    booking.tripTitle.isNotEmpty
                        ? booking.tripTitle
                        : 'شرم الشيخ - رحلات استجمام',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.p16.verticalSpace,

                  // Quick Stats Grid Cards (4 Grid Items)
                  Container(
                    padding: EdgeInsets.all(AppSizes.p12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        _buildGridStat(
                          icon: Icons.event,
                          label: 'الحالة',
                          value: statusText,
                          valueColor: statusColor,
                        ),
                        _buildGridStat(
                          icon: Icons.timer_outlined,
                          label: 'المدة',
                          value: _getBookingDuration(booking),
                        ),
                        _buildGridStat(
                          icon: Icons.calendar_month_outlined,
                          label: 'تاريخ الرحلة',
                          value: booking.tripDates.isNotEmpty
                              ? booking.tripDates
                              : '15 - 19 مايو 2026',
                        ),
                        _buildGridStat(
                          icon: Icons.receipt_long_outlined,
                          label: 'تاريخ الحجز',
                          value: booking.createdAt != null
                              ? '${booking.createdAt!.day}/${booking.createdAt!.month}/${booking.createdAt!.year}'
                              : 'اليوم',
                        ),
                      ],
                    ),
                  ),
                  AppSizes.p20.verticalSpace,

                  // تفاصيل المسافرين
                  Text(
                    'تفاصيل المسافرين',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.p8.verticalSpace,
                  Container(
                    padding: EdgeInsets.all(AppSizes.p16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildPassengerRow(
                          name: booking.customerName.isNotEmpty
                              ? booking.customerName
                              : 'أحمد محمد',
                          phone: booking.customerPhone.isNotEmpty
                              ? booking.customerPhone
                              : '+20 101 234 5678',
                          tag: 'المالك',
                          tagColor: AppColors.primary,
                        ),
                        if (booking.numberOfSeats > 1) ...[
                          const Divider(color: AppColors.border, height: 16),
                          _buildPassengerRow(
                            name: 'عدد الأفراد المحجوزة',
                            phone: '${booking.numberOfSeats} مقاعد',
                            tag: 'بالغ',
                            tagColor: AppColors.textHint,
                          ),
                        ],
                      ],
                    ),
                  ),
                  AppSizes.p20.verticalSpace,

                  // ملخص السعر
                  Text(
                    'ملخص السعر',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.p8.verticalSpace,
                  Container(
                    padding: EdgeInsets.all(AppSizes.p16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildPriceDetailRow(
                          'السعر الأساسي',
                          '${booking.totalPrice.toStringAsFixed(0)} ج.م',
                        ),
                        const Divider(color: AppColors.border, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الإجمالي',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${booking.totalPrice.toStringAsFixed(0)} ج.م',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSizes.p24.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridStat({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20.r, color: AppColors.primaryDark),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textHint,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textPrimary,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerRow({
    required String name,
    required String phone,
    required String tag,
    required Color tagColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              phone,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: tagColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            tag,
            style: AppTextStyles.labelSmall.copyWith(
              color: tagColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceDetailRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          val,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
