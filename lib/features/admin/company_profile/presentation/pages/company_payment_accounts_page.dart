import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_payment_account_model.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/cubit/company_payment_accounts_cubit.dart';

class CompanyPaymentAccountsPage extends StatelessWidget {
  final String companyId;

  const CompanyPaymentAccountsPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompanyPaymentAccountsCubit>(
      create: (context) =>
          getIt<CompanyPaymentAccountsCubit>()..loadPaymentAccounts(companyId),
      child: _CompanyPaymentAccountsBody(companyId: companyId),
    );
  }
}

class _CompanyPaymentAccountsBody extends StatelessWidget {
  final String companyId;

  const _CompanyPaymentAccountsBody({required this.companyId});

  void _showAddAccountBottomSheet(BuildContext context) {
    final cubit = context.read<CompanyPaymentAccountsCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddPaymentAccountBottomSheet(
        onSave: (newAccount) {
          cubit.addPaymentAccount(companyId, newAccount);
        },
      ),
    );
  }

  IconData _getProviderIcon(String provider) {
    switch (provider) {
      case 'instapay':
        return Icons.account_balance_wallet;
      case 'vodafone_cash':
      case 'orange_cash':
      case 'etisalat_cash':
      case 'wallet':
        return Icons.phone_android;
      case 'bank_transfer':
        return Icons.account_balance;
      case 'cash':
        return Icons.attach_money;
      default:
        return Icons.credit_card;
    }
  }

  String _getProviderLabel(String provider) {
    switch (provider) {
      case 'instapay':
        return 'InstaPay';
      case 'vodafone_cash':
        return 'Vodafone Cash';
      case 'orange_cash':
        return 'Orange Cash';
      case 'etisalat_cash':
        return 'Etisalat Cash';
      case 'wallet':
        return 'محفظة إلكترونية';
      case 'bank_transfer':
        return 'تحويل بنكي';
      case 'cash':
        return 'نقداً';
      default:
        return provider;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.companyPaymentAccountsTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryDark,
        onPressed: () => _showAddAccountBottomSheet(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          AppStrings.addPaymentAccountButton,
          style: AppTextStyles.labelMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<CompanyPaymentAccountsCubit, CompanyPaymentAccountsState>(
        listener: (context, state) {
          if (state is CompanyPaymentAccountsLoaded &&
              state.successMessage != null) {
            AppSnackbar.showSuccess(
              context: context,
              message: state.successMessage!,
            );
          } else if (state is CompanyPaymentAccountsError) {
            AppSnackbar.showError(
              context: context,
              message: state.error,
            );
          }
        },
        builder: (context, state) {
          if (state is CompanyPaymentAccountsLoading) {
            return const Center(child: AppLoading());
          }

          if (state is CompanyPaymentAccountsLoaded) {
            if (state.accounts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 64.r,
                      color: AppColors.textHint,
                    ),
                    AppSizes.p16.verticalSpace,
                    Text(
                      'لا توجد حسابات دفع مضافة حالياً',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSizes.p8.verticalSpace,
                    Text(
                      'أضف أرقام المحافظ وحسابات انستا باي الخاصة بشركتك لتلقي التحويلات',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(AppSizes.p16),
              itemCount: state.accounts.length,
              separatorBuilder: (context, index) => AppSizes.p12.verticalSpace,
              itemBuilder: (context, index) {
                final account = state.accounts[index];
                return Container(
                  padding: EdgeInsets.all(AppSizes.p16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: account.isActive
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getProviderIcon(account.provider),
                              color: AppColors.primaryDark,
                              size: 24.r,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.title.isNotEmpty
                                      ? account.title
                                      : _getProviderLabel(account.provider),
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  _getProviderLabel(account.provider),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: account.isActive,
                            activeTrackColor: AppColors.primaryDark,
                            onChanged: (_) {
                              context
                                  .read<CompanyPaymentAccountsCubit>()
                                  .toggleAccountActive(companyId, account.id);
                            },
                          ),
                        ],
                      ),
                      AppSizes.p12.verticalSpace,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppSizes.p12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              account.displayAddress,
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            if (account.instructions.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                account.instructions,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                            ),
                            onPressed: () {
                              context
                                  .read<CompanyPaymentAccountsCubit>()
                                  .deletePaymentAccount(companyId, account.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _AddPaymentAccountBottomSheet extends StatefulWidget {
  final ValueChanged<CompanyPaymentAccountModel> onSave;

  const _AddPaymentAccountBottomSheet({required this.onSave});

  @override
  State<_AddPaymentAccountBottomSheet> createState() =>
      _AddPaymentAccountBottomSheetState();
}

class _AddPaymentAccountBottomSheetState
    extends State<_AddPaymentAccountBottomSheet> {
  String _provider = 'instapay';
  final _titleController = TextEditingController();
  final _numberController = TextEditingController();
  final _handleController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _numberController.dispose();
    _handleController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p20).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.p20,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.addPaymentAccountButton,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            AppSizes.p16.verticalSpace,

            // Provider Dropdown
            DropdownButtonFormField<String>(
              initialValue: _provider,
              decoration: InputDecoration(
                labelText: AppStrings.accountProviderLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'instapay', child: Text('InstaPay')),
                DropdownMenuItem(
                    value: 'vodafone_cash', child: Text('Vodafone Cash')),
                DropdownMenuItem(
                    value: 'orange_cash', child: Text('Orange Cash')),
                DropdownMenuItem(
                    value: 'etisalat_cash', child: Text('Etisalat Cash')),
                DropdownMenuItem(
                    value: 'bank_transfer', child: Text('تحويل بنكي')),
                DropdownMenuItem(
                    value: 'cash', child: Text('نقداً عند اللقاء')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _provider = val);
              },
            ),
            AppSizes.p12.verticalSpace,

            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppStrings.accountTitleLabel,
                hintText: 'مثال: محفظة فودافون كاش الرئيسية',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            AppSizes.p12.verticalSpace,

            if (_provider == 'instapay') ...[
              TextField(
                controller: _handleController,
                decoration: InputDecoration(
                  labelText: AppStrings.accountHandleLabel,
                  hintText: 'company@instapay',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              AppSizes.p12.verticalSpace,
            ],

            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: AppStrings.accountNumberLabel,
                hintText: '01012345678',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            AppSizes.p12.verticalSpace,

            TextField(
              controller: _instructionsController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: AppStrings.accountInstructionsLabel,
                hintText: 'مثال: برجاء كتابة اسمك في الملاحظات عند التحويل',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            AppSizes.p20.verticalSpace,

            AppButton(
              text: 'حفظ الحساب ✨',
              onPressed: () {
                final account = CompanyPaymentAccountModel(
                  id: '',
                  provider: _provider,
                  title: _titleController.text.trim(),
                  number: _numberController.text.trim(),
                  handle: _handleController.text.trim(),
                  instructions: _instructionsController.text.trim(),
                  isActive: true,
                );
                widget.onSave(account);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
