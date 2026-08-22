import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/shared/widgets/app_text_field.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/core/utils/app_validators.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:fosha_app/features/user/auth/presentation/pages/reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            } else if (state is ForgotPasswordOtpSentState) {
              AppSnackbar.showSuccess(
                context: context,
                message: 'تم إرسال كود التحقق بنجاح إلى بريدك الإلكتروني',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResetPasswordPage(email: state.email),
                ),
              );
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
                        Icons.lock_reset_outlined,
                        size: 72.r,
                        color: AppColors.primary,
                      ),
                      AppSizes.p16.verticalSpace,
                      Text(
                        'نسيت كلمة المرور؟',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p8.verticalSpace,
                      Text(
                        'أدخل بريدك الإلكتروني ليصلك كود إعادة ضبط كلمة المرور',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSizes.p32.verticalSpace,
                      AppTextField(
                        controller: _emailController,
                        hintText: 'أدخل بريدك الإلكتروني',
                        labelText: 'البريد الإلكتروني',
                        type: AppTextFieldType.email,
                        validator: AppValidators.validateEmail,
                      ),
                      AppSizes.p32.verticalSpace,
                      AppButton(
                        text: 'إرسال كود التحقق',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().forgotPassword(
                                  email: _emailController.text.trim(),
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
