import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/customers/data/models/company_customer_model.dart';
import 'package:fosha_app/features/admin/customers/presentation/cubit/admin_customers_cubit.dart';
import 'package:fosha_app/features/admin/customers/presentation/widgets/admin_customer_card.dart';
import 'package:fosha_app/features/admin/customers/presentation/widgets/admin_customers_search_bar.dart';
import 'package:fosha_app/features/admin/customers/presentation/widgets/admin_customers_summary_banner.dart';
import 'package:fosha_app/features/admin/dashboard/data/repositories/admin_dashboard_stats_repository.dart';
import 'package:fosha_app/features/chat/data/models/chat_model.dart';
import 'package:fosha_app/features/chat/data/repositories/chat_repository.dart';
import 'package:fosha_app/features/chat/presentation/pages/chat_page.dart';

class AdminCustomersPage extends StatefulWidget {
  const AdminCustomersPage({super.key});

  @override
  State<AdminCustomersPage> createState() => _AdminCustomersPageState();
}

class _AdminCustomersPageState extends State<AdminCustomersPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminCustomersCubit>().fetchCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openCustomerChat(CompanyCustomerModel customer) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: AppLoading()),
    );

    try {
      final chatRepo = getIt<ChatRepository>();
      final result = await chatRepo.getUserChats();

      ChatModel? existingChat;

      result.fold(
        (_) {},
        (chats) {
          for (final chat in chats) {
            final matchId =
                customer.id.isNotEmpty && chat.userId == customer.id;
            final matchPhone = customer.phone.isNotEmpty &&
                chat.userPhone != null &&
                chat.userPhone == customer.phone;
            final matchName = customer.fullName.isNotEmpty &&
                chat.userName != null &&
                chat.userName == customer.fullName;

            if (matchId || matchPhone || matchName) {
              existingChat = chat;
              break;
            }
          }
        },
      );

      if (!mounted) return;
      Navigator.pop(context);

      if (existingChat != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(
              chatId: existingChat!.id,
              initialChat: existingChat,
              companyId: existingChat!.companyId,
              companyName: customer.fullName,
              companyPhone: customer.phone,
            ),
          ),
        );
      } else {
        final statsRepo = getIt<AdminDashboardStatsRepository>();
        final statsResult = await statsRepo.getDashboardStats();
        String compId = '';
        statsResult.fold((_) {}, (stats) {
          compId = stats.company?.id ?? '';
        });

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(
              companyId: compId,
              companyName: customer.fullName,
              companyPhone: customer.phone,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر فتح المحادثة: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Text(
          AppStrings.adminCustomersTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AdminCustomersCubit, AdminCustomersState>(
        builder: (context, state) {
          if (state is AdminCustomersLoading) {
            return const Center(child: AppLoading());
          }

          if (state is AdminCustomersError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64.r,
                      color: AppColors.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<AdminCustomersCubit>()
                          .fetchCustomers(search: _searchController.text.trim()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          final customers =
              state is AdminCustomersLoaded ? state.customers : <CompanyCustomerModel>[];
          final totalSpentAll = customers.fold<double>(
            0.0,
            (sum, item) => sum + item.totalSpent,
          );

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<AdminCustomersCubit>().fetchCustomers(
                    search: _searchController.text.trim(),
                  );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminCustomersSummaryBanner(
                    totalCustomers: customers.length,
                    totalSpentSum: totalSpentAll,
                  ),
                  SizedBox(height: 16.h),

                  AdminCustomersSearchBar(
                    controller: _searchController,
                    onChanged: (val) {
                      context.read<AdminCustomersCubit>().fetchCustomers(
                            search: val.trim(),
                          );
                    },
                    onClear: () {
                      _searchController.clear();
                      context.read<AdminCustomersCubit>().fetchCustomers();
                    },
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppStrings.adminCustomerDataSection} (${customers.length})',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            context.read<AdminCustomersCubit>().fetchCustomers();
                          },
                          child: Text(AppStrings.adminCustomersClearSearch),
                        ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  if (customers.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: customers.length,
                      separatorBuilder: (context, index) => SizedBox(height: 14.h),
                      itemBuilder: (context, index) {
                        return AdminCustomerCard(
                          customer: customers[index],
                          onOpenChat: () => _openCustomerChat(customers[index]),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 64.r,
              color: AppColors.textHint,
            ),
            SizedBox(height: 12.h),
            Text(
              AppStrings.adminCustomersNoResults,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
