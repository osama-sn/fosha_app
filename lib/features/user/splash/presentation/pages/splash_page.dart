import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_assets.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_states.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
      child: Scaffold(
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (!context.mounted) return;
              if (state is AuthSuccess) {
                if (state.user.isAdmin) {
                  context.go(RouteNames.adminDashboard);
                } else {
                  context.go(RouteNames.home);
                }
              } else if (state is AuthInitial || state is AuthFailure) {
                context.go(RouteNames.login);
              }
            });
          },
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  AppAssets.splashBackground,
                  fit: BoxFit.cover,
                ),
              ),

              // Bottom Gradient Overlay for readability
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 300.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.primaryDark.withValues(alpha: 0.9),
                        AppColors.primaryDark.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Main Content
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // Logo without background container
                      Image.asset(
                        AppAssets.logo,
                        width: 170.w,
                        height: 170.w,
                        fit: BoxFit.contain,
                      ),
                      const Spacer(flex: 6),
                      // Loading Indicator Area
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.p24),
                        child: Column(
                          children: [
                            Text(
                              AppStrings.splashLoading,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            SizedBox(height: AppSizes.p8),
                            Text(
                              AppStrings.splashVerifyingLogin,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            SizedBox(height: AppSizes.p24),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppSizes.r32),
                              child: SizedBox(
                                width: double.infinity,
                                height: 6.h,
                                child: const LinearProgressIndicator(
                                  backgroundColor: Colors.white24,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.surface,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSizes.p32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
