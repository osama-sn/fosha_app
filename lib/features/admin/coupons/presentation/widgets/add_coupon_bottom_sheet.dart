import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/coupons/presentation/cubit/coupons_cubit.dart';
import 'package:intl/intl.dart';

class AddCouponBottomSheet extends StatefulWidget {
  const AddCouponBottomSheet({super.key});

  @override
  State<AddCouponBottomSheet> createState() => _AddCouponBottomSheetState();
}

class _AddCouponBottomSheetState extends State<AddCouponBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _discountController;
  late final TextEditingController _maxDiscountController;
  late final TextEditingController _minPriceController;
  late final TextEditingController _usageLimitController;

  DateTime _selectedValidUntil = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _discountController = TextEditingController();
    _maxDiscountController = TextEditingController(text: '0');
    _minPriceController = TextEditingController(text: '0');
    _usageLimitController = TextEditingController(text: '50');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _discountController.dispose();
    _maxDiscountController.dispose();
    _minPriceController.dispose();
    _usageLimitController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedValidUntil,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _selectedValidUntil = DateTime(
          picked.year,
          picked.month,
          picked.day,
          23,
          59,
          59,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: AppSizes.p16,
        left: AppSizes.p16,
        right: AppSizes.p16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header indicator
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              AppSizes.p12.verticalSpace,

              Text(
                AppStrings.addCouponTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              AppSizes.p16.verticalSpace,

              // Coupon Code Field
              TextFormField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return AppStrings.couponCodeRequired;
                  }
                  if (v.trim().length < 3) {
                    return AppStrings.couponCodeMinLength;
                  }
                  return null;
                },
                decoration: _buildInputDecoration(
                  label: '${AppStrings.couponCodeLabel} (${AppStrings.couponCodeHint}) *',
                  prefixIcon: Icons.confirmation_number_outlined,
                ),
              ),
              AppSizes.p12.verticalSpace,

              // Discount % & Usage Limit
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return AppStrings.discountPercentageRequired;
                        final val = double.tryParse(v);
                        if (val == null || val <= 0 || val > 100) {
                          return AppStrings.discountPercentageInvalid;
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration(
                        label: '${AppStrings.discountPercentageLabel} *',
                        prefixIcon: Icons.percent,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: _usageLimitController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        label: AppStrings.usageLimitLabel,
                        prefixIcon: Icons.people_outline,
                      ),
                    ),
                  ),
                ],
              ),
              AppSizes.p12.verticalSpace,

              // Max Discount & Min Price
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _maxDiscountController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        label: AppStrings.maxDiscountLabel,
                        prefixIcon: Icons.attach_money,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: _minPriceController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        label: AppStrings.minTripPriceLabel,
                        prefixIcon: Icons.shopping_bag_outlined,
                      ),
                    ),
                  ),
                ],
              ),
              AppSizes.p12.verticalSpace,

              // Date Picker
              InkWell(
                onTap: _selectExpiryDate,
                child: Container(
                  padding: EdgeInsets.all(AppSizes.p12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_available,
                        color: AppColors.primaryDark,
                        size: 20.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${AppStrings.validUntilLabel}: ${DateFormat('yyyy/MM/dd').format(_selectedValidUntil)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSizes.p20.verticalSpace,

              // Submit Button
              AppButton(
                text: AppStrings.addCouponTitle,
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    final discount =
                        double.tryParse(_discountController.text.trim()) ?? 0.0;
                    final maxDiscount =
                        double.tryParse(_maxDiscountController.text.trim()) ??
                            0.0;
                    final minPrice =
                        double.tryParse(_minPriceController.text.trim()) ?? 0.0;
                    final usageLimit =
                        int.tryParse(_usageLimitController.text.trim()) ?? 0;

                    context.read<CouponsCubit>().createCoupon(
                          code: _codeController.text.trim().toUpperCase(),
                          discountPercentage: discount,
                          maxDiscountAmount: maxDiscount,
                          minTripPrice: minPrice,
                          validUntil: _selectedValidUntil,
                          usageLimit: usageLimit,
                        );
                    Navigator.of(context).pop();
                  }
                },
              ),
              AppSizes.p20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
      prefixIcon: Icon(prefixIcon, color: AppColors.primaryDark, size: 18.r),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p10,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.primaryDark),
      ),
    );
  }
}
