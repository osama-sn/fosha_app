import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_assets.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/extensions/widget_extension.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/shared/widgets/app_text_field.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/core/utils/app_validators.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:fosha_app/features/user/auth/presentation/widgets/social_auth_buttons.dart';
import 'package:fosha_app/features/user/auth/presentation/pages/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                AppSnackbar.showSuccess(
                  context: context,
                  message: AppStrings.loginSuccessMessage,
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
                      vertical: AppSizes.p32,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          16.h.verticalSpace,
                          Center(
                            child: Image.asset(
                              AppAssets.loginIllustration,
                              height: 140.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          16.h.verticalSpace,
                          Text(
                            AppStrings.welcome,
                            style: AppTextStyles.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                          AppSizes.p8.verticalSpace,
                          Text(
                            AppStrings.loginSubtitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          24.h.verticalSpace,
                          AppTextField(
                            controller: _emailController,
                            hintText: AppStrings.emailHint,
                            labelText: AppStrings.emailLabel,
                            type: AppTextFieldType.email,
                            validator: AppValidators.validateEmail,
                          ),
                          AppSizes.p16.verticalSpace,
                          AppTextField(
                            controller: _passwordController,
                            hintText: AppStrings.passwordHint,
                            labelText: AppStrings.passwordLabel,
                            type: AppTextFieldType.password,
                            validator: AppValidators.validatePassword,
                          ),
                          AppSizes.p8.verticalSpace,
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ForgotPasswordPage(),
                                  ),
                                );
                              },
                              child: Text(
                                AppStrings.forgotPassword,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          AppSizes.p24.verticalSpace,
                          AppButton(
                            text: AppStrings.login,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().login(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                );
                              }
                            },
                          ),
                          AppSizes.p32.verticalSpace,
                          SocialAuthButtons(),
                          40.h.verticalSpace,
                          RichText(
                            text: TextSpan(
                              text: AppStrings.dontHaveAccount,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: AppStrings.register,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        context.go(RouteNames.register),
                                ),
                              ],
                            ),
                          ).center(),
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
