import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/cubit/company_profile_cubit.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/cubit/company_profile_state.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/widgets/company_profile_form.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/widgets/company_profile_header_banner.dart';
import 'package:fosha_app/features/user/auth/data/repositories/auth_repository.dart';

class CompanyProfilePage extends StatefulWidget {
  final String? companyId;

  const CompanyProfilePage({super.key, this.companyId});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  late final CompanyProfileCubit _cubit;
  String _effectiveCompanyId = '';
  bool _isLoadingId = true;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CompanyProfileCubit>();
    _initCompanyId();
  }

  Future<void> _initCompanyId() async {
    String id = widget.companyId ?? '';
    if (id.isEmpty) {
      try {
        final user = await getIt<AuthRepository>().getCachedUser();
        id = user?.company ?? '';
      } catch (_) {}
    }
    if (mounted) {
      setState(() {
        _effectiveCompanyId = id;
        _isLoadingId = false;
      });
      if (id.isNotEmpty) {
        _cubit.loadCompanyProfile(id);
      }
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompanyProfileCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'تعديل ملف الشركة',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoadingId
            ? const AppLoading()
            : BlocConsumer<CompanyProfileCubit, CompanyProfileState>(
                listener: (context, state) {
                  if (state is CompanyProfileUpdateSuccess) {
                    AppSnackbar.showSuccess(
                      context: context,
                      message: state.message,
                    );
                  } else if (state is CompanyProfileFailure) {
                    AppSnackbar.showError(
                      context: context,
                      message: state.error,
                    );
                  }
                },
                builder: (context, state) {
                  if (_effectiveCompanyId.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.p20),
                        child: Text(
                          'لم يتم العثور على معرف الشركة الحالي',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is CompanyProfileLoading) {
                    return const AppLoading();
                  }

                  CompanyProfileModel? currentProfile;
                  if (state is CompanyProfileLoaded) {
                    currentProfile = state.profile;
                  } else if (state is CompanyProfileUpdating) {
                    currentProfile = state.currentProfile;
                  } else if (state is CompanyProfileUpdateSuccess) {
                    currentProfile = state.profile;
                  }

                  final isUpdating = state is CompanyProfileUpdating;

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(AppSizes.p16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CompanyProfileHeaderBanner(),
                        AppSizes.p20.verticalSpace,
                        CompanyProfileForm(
                          companyId: _effectiveCompanyId,
                          initialProfile: currentProfile,
                          isUpdating: isUpdating,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
