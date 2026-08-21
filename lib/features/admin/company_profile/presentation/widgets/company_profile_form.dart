import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_governorates.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/cubit/company_profile_cubit.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/widgets/company_profile_form_field.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/widgets/company_profile_governorate_picker.dart';

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
      _selectedGovernorate = governorates.isNotEmpty ? governorates.first : '';
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
          CompanyProfileFormField(
            label: AppStrings.companyNameLabel,
            hintText: AppStrings.companyNameHint,
            prefixIcon: Icons.business_outlined,
            controller: _nameController,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return AppStrings.companyNameRequired;
              }
              return null;
            },
          ),
          AppSizes.p16.verticalSpace,

          CompanyProfileFormField(
            label: AppStrings.companyDescLabel,
            hintText: AppStrings.companyDescHint,
            prefixIcon: Icons.description_outlined,
            controller: _descriptionController,
            maxLines: 3,
            minLines: 2,
          ),
          AppSizes.p16.verticalSpace,

          CompanyProfileFormField(
            label: AppStrings.companyPhoneLabel,
            hintText: AppStrings.phoneHint,
            prefixIcon: Icons.phone_outlined,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return AppStrings.companyPhoneRequired;
              }
              return null;
            },
          ),
          AppSizes.p16.verticalSpace,

          CompanyProfileFormField(
            label: AppStrings.companyEmailLabel,
            hintText: AppStrings.emailHint,
            prefixIcon: Icons.email_outlined,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return AppStrings.companyEmailRequired;
              }
              if (!val.contains('@')) {
                return AppStrings.companyEmailInvalid;
              }
              return null;
            },
          ),
          AppSizes.p16.verticalSpace,

          CompanyProfileFormField(
            label: AppStrings.companyAddressLabel,
            hintText: AppStrings.companyAddressHint,
            prefixIcon: Icons.location_on_outlined,
            controller: _addressController,
          ),
          AppSizes.p16.verticalSpace,

          Text(
            AppStrings.companyGovernorateLabel,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          AppSizes.p8.verticalSpace,
          CompanyProfileGovernoratePicker(
            selectedGovernorate: _selectedGovernorate,
            governoratesList: governoratesList,
            onChanged: (String newValue) {
              setState(() {
                _selectedGovernorate = newValue;
              });
            },
          ),
          28.h.verticalSpace,

          AppButton(
            text: widget.isUpdating ? AppStrings.savingChanges : AppStrings.saveChanges,
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
}
