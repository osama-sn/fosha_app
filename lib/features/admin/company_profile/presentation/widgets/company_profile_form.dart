import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_governorates.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/cubit/company_profile_cubit.dart';

class CompanyProfileForm extends StatefulWidget {
  final String companyId;
  final CompanyProfileModel? initialProfile;
  final bool isUpdating;

  const CompanyProfileForm({
    super.key,
    required this.companyId,
    this.initialProfile,
    required this.isUpdating,
  });

  @override
  State<CompanyProfileForm> createState() => _CompanyProfileFormState();
}

class _CompanyProfileFormState extends State<CompanyProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  late String _selectedGovernorate;

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    final governorates = AppGovernorates.arabicNames;

    _nameController = TextEditingController(text: profile?.name ?? '');
    _descriptionController =
        TextEditingController(text: profile?.description ?? '');
    _phoneController = TextEditingController(text: profile?.contactPhone ?? '');
    _emailController = TextEditingController(text: profile?.contactEmail ?? '');
    _addressController = TextEditingController(text: profile?.address ?? '');

    final initialGov = profile?.governorate ?? '';
    if (initialGov.isNotEmpty && governorates.contains(initialGov)) {
      _selectedGovernorate = initialGov;
    } else {
      _selectedGovernorate = governorates.isNotEmpty ? governorates.first : 'المنيا';
    }
  }

  @override
  void didUpdateWidget(covariant CompanyProfileForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialProfile != oldWidget.initialProfile &&
        widget.initialProfile != null) {
      final p = widget.initialProfile!;
      _nameController.text = p.name;
      _descriptionController.text = p.description;
      _phoneController.text = p.contactPhone;
      _emailController.text = p.contactEmail;
      _addressController.text = p.address;
      if (p.governorate.isNotEmpty &&
          AppGovernorates.arabicNames.contains(p.governorate)) {
        _selectedGovernorate = p.governorate;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final governoratesList = AppGovernorates.arabicNames;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name field
          _buildSectionTitle('اسم الشركة'),
          AppSizes.p8.verticalSpace,
          TextFormField(
            controller: _nameController,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'يرجى إدخال اسم الشركة';
              }
              return null;
            },
            decoration: _buildInputDecoration(
              hintText: 'مثال: شركة فسحني شكرا للسياحة',
              prefixIcon: Icons.business_outlined,
            ),
          ),
          AppSizes.p16.verticalSpace,

          // Description field
          _buildSectionTitle('وصف الشركة'),
          AppSizes.p8.verticalSpace,
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            minLines: 2,
            decoration: _buildInputDecoration(
              hintText: 'وصف ورؤية الشركة ورحلاتها...',
              prefixIcon: Icons.description_outlined,
            ),
          ),
          AppSizes.p16.verticalSpace,

          // Phone field
          _buildSectionTitle('هاتف التواصل'),
          AppSizes.p8.verticalSpace,
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'يرجى إدخال رقم الهاتف';
              }
              return null;
            },
            decoration: _buildInputDecoration(
              hintText: '+201011111111',
              prefixIcon: Icons.phone_outlined,
            ),
          ),
          AppSizes.p16.verticalSpace,

          // Email field
          _buildSectionTitle('البريد الإلكتروني للتواصل'),
          AppSizes.p8.verticalSpace,
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'يرجى إدخال البريد الإلكتروني';
              }
              if (!val.contains('@')) {
                return 'البريد الإلكتروني غير صحيح';
              }
              return null;
            },
            decoration: _buildInputDecoration(
              hintText: 'info@company.com',
              prefixIcon: Icons.email_outlined,
            ),
          ),
          AppSizes.p16.verticalSpace,

          // Address field
          _buildSectionTitle('العنوان التفصيلي'),
          AppSizes.p8.verticalSpace,
          TextFormField(
            controller: _addressController,
            decoration: _buildInputDecoration(
              hintText: 'المنيا - كورنيش النيل',
              prefixIcon: Icons.location_on_outlined,
            ),
          ),
          AppSizes.p16.verticalSpace,

          // Governorate field
          _buildSectionTitle('المحافظة'),
          AppSizes.p8.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p12,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: governoratesList.contains(_selectedGovernorate)
                    ? _selectedGovernorate
                    : governoratesList.first,
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primaryDark,
                ),
                items: governoratesList.map((String gov) {
                  return DropdownMenuItem<String>(
                    value: gov,
                    child: Text(
                      gov,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedGovernorate = newValue;
                    });
                  }
                },
              ),
            ),
          ),
          28.h.verticalSpace,

          // Save Button
          AppButton(
            text: widget.isUpdating ? 'جاري الحفظ...' : 'حفظ التغييرات',
            isLoading: widget.isUpdating,
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                context.read<CompanyProfileCubit>().updateCompanyProfile(
                      companyId: widget.companyId,
                      name: _nameController.text.trim(),
                      description: _descriptionController.text.trim(),
                      contactPhone: _phoneController.text.trim(),
                      contactEmail: _emailController.text.trim(),
                      address: _addressController.text.trim(),
                      governorate: _selectedGovernorate,
                    );
              }
            },
          ),
          AppSizes.p20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.labelLarge.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
      prefixIcon: Icon(prefixIcon, color: AppColors.primaryDark, size: 20.r),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p12,
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
        borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
      ),
    );
  }
}
