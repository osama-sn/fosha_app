import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:fosha_app/core/constants/app_assets.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/user/auth/data/models/user_model.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_states.dart';
import 'package:fosha_app/features/user/profile/presentation/widgets/profile_menu_item_widget.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              centerTitle: true,
              title: Text(
                AppStrings.profileTitle,
                style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary),
              ),
              leading: IconButton(
                icon: Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings_outlined, color: AppColors.textPrimary),
                  onPressed: () => context.push(RouteNames.settings),
                ),
              ],
            ),
            body: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final user = state is AuthSuccess ? state.user : null;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(AppSizes.p24),
                  child: Column(
                    children: [
                      _buildHeader(user),
                      AppSizes.p32.verticalSpace,
                      _buildOptionsList(),
                      AppSizes.p32.verticalSpace,
                      _buildLogoutButton(context),
                      AppSizes.p32.verticalSpace,
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(UserModel? user) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: AppColors.border,
              backgroundImage: (user != null && user.profileImage.isNotEmpty)
                  ? NetworkImage(user.profileImage) as ImageProvider
                  : AssetImage(AppAssets.placeholder),
            ),
            Container(
              padding: EdgeInsets.all(AppSizes.p4),
              decoration: BoxDecoration(
                color: const Color(0xFF91590F),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
            ),
          ],
        ),
        AppSizes.p16.verticalSpace,
        Text(
          user?.fullName.isNotEmpty == true ? user!.fullName : 'المستخدم',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (user?.email.isNotEmpty == true) ...[
          AppSizes.p4.verticalSpace,
          Text(
            user!.email,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
        if (user?.phone.isNotEmpty == true) ...[
          AppSizes.p4.verticalSpace,
          Text(
            user!.phone,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }

  Widget _buildOptionsList() {
    return Column(
      children: [
        ProfileMenuItemWidget(title: AppStrings.profilePersonalData, icon: Icons.person_outline),
        AppSizes.p12.verticalSpace,
        ProfileMenuItemWidget(title: AppStrings.profileEditAccount, icon: Icons.edit_outlined),
        AppSizes.p12.verticalSpace,
        ProfileMenuItemWidget(title: AppStrings.profileChangePassword, icon: Icons.lock_outline),
        AppSizes.p12.verticalSpace,
        ProfileMenuItemWidget(title: AppStrings.profileHelpSupport, icon: Icons.help_outline),
        AppSizes.p12.verticalSpace,
        ProfileMenuItemWidget(title: AppStrings.profileAboutApp, icon: Icons.info_outline),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton.outlined(
        text: AppStrings.profileLogout,
        foregroundColor: Colors.red,
        borderColor: Colors.red.withValues(alpha: 0.3),
        icon: Icon(Icons.logout, color: Colors.red, size: 20.sp),
        onPressed: () => _showLogoutDialog(context),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت تأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().logout();
      if (context.mounted) {
        AppSnackbar.showSuccess(
          context: context,
          message: 'تم تسجيل الخروج بنجاح',
        );
        context.go(RouteNames.login);
      }
    }
  }
}

