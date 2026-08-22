import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/shared/widgets/app_text_field.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/core/utils/app_validators.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_cubit.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              AppSnackbar.showError(
                context: context,
                message: state.errorMessage,
              );
            } else if (state is ResetPasswordSuccessState) {
              AppSnackbar.showSuccess(
                context: context,
                message: 'تم إعادة ضبط كلمة المرور بنجاح! يمكنك الآن تسجيل الدخول',
              );
              context.go(RouteNames.login);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.p24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppSizes.p24.verticalSpace,
                      Icon(
                        Icons.mark_email_read_outlined,
                        size: 72.r,
                        color: AppColors.primary,
                      ),
                      AppSizes.p16.verticalSpace,
                      Text(
                        'إعادة ضبط كلمة المرور',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p8.verticalSpace,
                      Text(
                        'أدخل كود التحقق المرسل إلى ${widget.email} وكلمة المرور الجديدة',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSizes.p32.verticalSpace,
                      AppTextField(
                        controller: _otpController,
                        hintText: 'كود التحقق OTP',
                        labelText: 'كود التحقق',
                        type: AppTextFieldType.phone,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'أدخل كود التحقق' : null,
                      ),
                      AppSizes.p16.verticalSpace,
                      AppTextField(
                        controller: _passwordController,
                        hintText: 'كلمة المرور الجديدة',
                        labelText: 'كلمة المرور الجديدة',
                        type: AppTextFieldType.password,
                        validator: AppValidators.validatePassword,
                      ),
                      AppSizes.p32.verticalSpace,
                      AppButton(
                        text: 'حفظ وتحديث كلمة المرور',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().resetPassword(
                                  email: widget.email,
                                  otp: _otpController.text.trim(),
                                  newPassword: _passwordController.text.trim(),
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
