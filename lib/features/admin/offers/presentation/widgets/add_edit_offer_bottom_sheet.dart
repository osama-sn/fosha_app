import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/offers/data/models/offer_model.dart';
import 'package:fosha_app/features/admin/offers/presentation/cubit/offers_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEditOfferBottomSheet extends StatefulWidget {
  final OfferModel? offerToEdit;

  const AddEditOfferBottomSheet({super.key, this.offerToEdit});

  @override
  State<AddEditOfferBottomSheet> createState() =>
      _AddEditOfferBottomSheetState();
}

class _AddEditOfferBottomSheetState extends State<AddEditOfferBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleArController;
  late final TextEditingController _titleEnController;
  late final TextEditingController _descArController;
  late final TextEditingController _descEnController;
  late final TextEditingController _discountController;
  late final TextEditingController _promoCodeController;
  late final TextEditingController _priorityController;

  File? _selectedImage;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    final offer = widget.offerToEdit;

    _titleArController = TextEditingController(text: offer?.titleAr ?? '');
    _titleEnController = TextEditingController(text: offer?.titleEn ?? '');
    _descArController =
        TextEditingController(text: offer?.descriptionAr ?? '');
    _descEnController =
        TextEditingController(text: offer?.descriptionEn ?? '');
    _discountController = TextEditingController(
      text: offer != null ? offer.discountPercentage.toStringAsFixed(0) : '',
    );
    _promoCodeController = TextEditingController(text: offer?.promoCode ?? '');
    _priorityController = TextEditingController(
      text: offer != null ? offer.priority.toString() : '0',
    );
    _selectedEndDate = offer?.endDate;
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _descArController.dispose();
    _descEnController.dispose();
    _discountController.dispose();
    _promoCodeController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.offerToEdit != null;

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
              // Header Indicator
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

              // Title
              Text(
                isEditing ? AppStrings.editOfferTitle : AppStrings.addOfferTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              AppSizes.p16.verticalSpace,

              // Image Selector
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : (isEditing && widget.offerToEdit!.image.isNotEmpty
                          ? Center(
                              child: Text(
                                AppStrings.changeOfferImage,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 36.r,
                                  color: AppColors.primaryDark,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  AppStrings.selectOfferImage,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            )),
                ),
              ),
              AppSizes.p16.verticalSpace,

              // Title AR & EN
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _titleArController,
                      validator: (v) => v == null || v.isEmpty
                          ? AppStrings.titleArLabel
                          : null,
                      decoration: _buildInputDecoration(AppStrings.titleArLabel),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: _titleEnController,
                      validator: (v) => v == null || v.isEmpty
                          ? AppStrings.titleEnLabel
                          : null,
                      decoration: _buildInputDecoration(AppStrings.titleEnLabel),
                    ),
                  ),
                ],
              ),
              AppSizes.p12.verticalSpace,

              // Description AR
              TextFormField(
                controller: _descArController,
                maxLines: 2,
                decoration: _buildInputDecoration(AppStrings.descArLabel),
              ),
              AppSizes.p12.verticalSpace,

              // Discount & Promo Code
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
                      decoration: _buildInputDecoration('${AppStrings.discountPercentageLabel} *'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: _promoCodeController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: _buildInputDecoration(AppStrings.promoCodeLabel),
                    ),
                  ),
                ],
              ),
              AppSizes.p12.verticalSpace,

              // Expiry Date Selector
              InkWell(
                onTap: _selectEndDate,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.p12,
                    vertical: AppSizes.p12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: AppColors.primaryDark,
                        size: 20.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _selectedEndDate != null
                            ? '${AppStrings.endDateLabel}: ${DateFormat('yyyy/MM/dd').format(_selectedEndDate!)}'
                            : AppStrings.selectEndDateOptional,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _selectedEndDate != null
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSizes.p20.verticalSpace,

              // Submit Button
              AppButton(
                text: isEditing ? AppStrings.saveChanges : AppStrings.addOfferTitle,
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    if (!isEditing && _selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppStrings.selectOfferImageRequired),
                        ),
                      );
                      return;
                    }

                    final discount =
                        double.tryParse(_discountController.text.trim()) ?? 0.0;
                    final priority =
                        int.tryParse(_priorityController.text.trim()) ?? 0;

                    if (isEditing) {
                      context.read<OffersCubit>().updateOffer(
                            offerId: widget.offerToEdit!.id,
                            titleAr: _titleArController.text.trim(),
                            titleEn: _titleEnController.text.trim(),
                            descriptionAr: _descArController.text.trim(),
                            descriptionEn: _descEnController.text.trim(),
                            discountPercentage: discount,
                            promoCode:
                                _promoCodeController.text.trim().toUpperCase(),
                            endDate: _selectedEndDate,
                            priority: priority,
                            imageFile: _selectedImage,
                          );
                    } else {
                      context.read<OffersCubit>().createOffer(
                            titleAr: _titleArController.text.trim(),
                            titleEn: _titleEnController.text.trim(),
                            descriptionAr: _descArController.text.trim(),
                            descriptionEn: _descEnController.text.trim(),
                            discountPercentage: discount,
                            promoCode:
                                _promoCodeController.text.trim().toUpperCase(),
                            endDate: _selectedEndDate,
                            priority: priority,
                            imageFile: _selectedImage,
                          );
                    }
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

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
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
