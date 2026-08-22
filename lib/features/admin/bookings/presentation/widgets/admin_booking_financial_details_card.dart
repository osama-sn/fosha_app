import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminBookingFinancialDetailsCard extends StatelessWidget {
  final String bookingNumber;
  final String requestDate;
  final String passengersCount;
  final String paymentMethod;
  final String paymentSenderInstaPay;
  final String paymentSenderNumber;
  final String paymentNotes;
  final String pickupPoint;
  final String pickupTime;
  final String totalAmount;

  const AdminBookingFinancialDetailsCard({
    super.key,
    required this.bookingNumber,
    required this.requestDate,
    required this.passengersCount,
    required this.paymentMethod,
    this.paymentSenderInstaPay = '',
    this.paymentSenderNumber = '',
    this.paymentNotes = '',
    this.pickupPoint = '',
    this.pickupTime = '',
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(
            AppStrings.adminBookingNumberLabel,
            bookingNumber,
            isHighlight: true,
          ),
          AppSizes.p12.verticalSpace,
          _buildDetailRow(AppStrings.adminRequestDateLabel, requestDate),
          AppSizes.p12.verticalSpace,
          _buildDetailRow(
            AppStrings.adminPassengersCountLabel,
            passengersCount,
          ),
          AppSizes.p12.verticalSpace,
          _buildDetailRow(AppStrings.adminPaymentMethodLabel, paymentMethod),
          if (paymentSenderInstaPay.isNotEmpty) ...[
            AppSizes.p12.verticalSpace,
            _buildDetailRow('حساب انستا باي', paymentSenderInstaPay),
          ],
          if (paymentSenderNumber.isNotEmpty) ...[
            AppSizes.p12.verticalSpace,
            _buildDetailRow('رقم المحول منه', paymentSenderNumber),
          ],
          if (pickupPoint.isNotEmpty) ...[
            AppSizes.p12.verticalSpace,
            _buildDetailRow('نقطة التجمع', pickupPoint),
          ],
          if (pickupTime.isNotEmpty) ...[
            AppSizes.p12.verticalSpace,
            _buildDetailRow('موعد التجمع', pickupTime),
          ],
          if (paymentNotes.isNotEmpty) ...[
            AppSizes.p12.verticalSpace,
            _buildDetailRow('ملاحظات الدفع', paymentNotes),
          ],
          AppSizes.p12.verticalSpace,
          const Divider(color: AppColors.divider),
          AppSizes.p8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.adminTotalAmountLabel,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                totalAmount,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            color: isHighlight ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
