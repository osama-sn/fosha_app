import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_governorates.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/shared/widgets/app_text_field.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/core/utils/app_validators.dart';
import 'package:fosha_app/features/user/auth/data/models/register_request_model.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_states.dart';
import 'package:fosha_app/features/user/auth/presentation/widgets/profile_avatar_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGovernorate;
  String? _profileImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    return BlocProvider<AuthCubit>(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primary,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                AppSnackbar.showSuccess(
                  context: context,
                  message: AppStrings.success,
                );
                if (state.user.isAdmin) {
                  context.go(RouteNames.adminDashboard);
                } else {
                  context.go(RouteNames.home);
                }
              } else if (state is AuthFailure) {
                AppSnackbar.showError(
                  context: context,
                  message: state.errorMessage,
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.p24,
                      vertical: AppSizes.p16,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.createAccountTitle,
                            style: AppTextStyles.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                          AppSizes.p8.verticalSpace,
                          Text(
                            AppStrings.createAccountSubtitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          32.h.verticalSpace,
                          ProfileAvatarPicker(
                            imagePath: _profileImagePath,
                            onTap: _pickImage,
                          ),
                          32.h.verticalSpace,
                          AppTextField(
                            controller: _nameController,
                            hintText: AppStrings.nameHint,
                            labelText: AppStrings.nameLabel,
                            type: AppTextFieldType.text,
                            validator: AppValidators.validateName,
                          ),
                          AppSizes.p16.verticalSpace,
                          AppTextField(
                            controller: _emailController,
                            hintText: AppStrings.emailHint,
                            labelText: AppStrings.emailLabel,
                            type: AppTextFieldType.email,
                            validator: AppValidators.validateEmail,
                          ),
                          AppSizes.p16.verticalSpace,
                          AppTextField(
                            controller: _phoneController,
                            hintText: AppStrings.phoneHint,
                            labelText: AppStrings.phoneLabel,
                            type: AppTextFieldType.phone,
                            validator: AppValidators.validatePhone,
                          ),
                          AppSizes.p16.verticalSpace,
                          DropdownButtonFormField<String>(
                            initialValue: _selectedGovernorate,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: AppStrings.governorateLabel,
                              hintText: AppStrings.governorateHint,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppSizes.p16,
                                vertical: AppSizes.p16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.r12,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.divider,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.r12,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.divider,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.r12,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            items: AppGovernorates.governorates
                                .map(
                                  (g) => DropdownMenuItem<String>(
                                    value: g.nameAr,
                                    child: Text(
                                      g.getName(langCode),
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGovernorate = value;
                              });
                            },
                          ),
                          AppSizes.p16.verticalSpace,
                          AppTextField(
                            controller: _passwordController,
                            hintText: AppStrings.passwordHint,
                            labelText: AppStrings.passwordLabel,
                            type: AppTextFieldType.password,
                            validator: AppValidators.validatePassword,
                          ),
                          AppSizes.p16.verticalSpace,
                          AppTextField(
                            controller: _confirmPasswordController,
                            hintText: AppStrings.confirmPasswordHint,
                            labelText: AppStrings.confirmPasswordLabel,
                            type: AppTextFieldType.password,
                            validator: (value) =>
                                AppValidators.validateConfirmPassword(
                                  value,
                                  _passwordController.text,
                                ),
                          ),
                          AppSizes.p32.verticalSpace,
                          AppButton(
                            text: AppStrings.register,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final request = RegisterRequestModel(
                                  fullName: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  governorate: _selectedGovernorate,
                                  password: _passwordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text,
                                  profileImagePath: _profileImagePath,
                                );
                                context.read<AuthCubit>().register(request);
                              }
                            },
                          ),
                          AppSizes.p32.verticalSpace,
                          RichText(
                            text: TextSpan(
                              text: AppStrings.alreadyHaveAccount,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: AppStrings.login,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        context.go(RouteNames.login),
                                ),
                              ],
                            ),
                          ).center(),
                          AppSizes.p32.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                  if (state is AuthLoading)
                    Container(
                      color: Colors.black.withAlpha(76),
                      child: const AppLoading(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
