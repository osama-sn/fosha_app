import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/user/search/presentation/cubit/search_cubit.dart';
import 'package:fosha_app/features/user/search/presentation/widgets/search_filters_form.dart';
import 'package:fosha_app/features/user/search/presentation/widgets/search_results_list.dart';

class SearchPage extends StatelessWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) {
        final cubit = getIt<SearchCubit>();
        if (initialQuery != null && initialQuery!.isNotEmpty) {
          cubit.setSearchQuery(initialQuery);
        }
        cubit.fetchCompanies();
        cubit.performSearch();
        return cubit;
      },
      child: const _SearchPageBody(),
    );
  }
}

class _SearchPageBody extends StatefulWidget {
  const _SearchPageBody();

  @override
  State<_SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<_SearchPageBody> {
  bool _showFilters = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          AppStrings.searchTripsTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.tune : Icons.tune_outlined,
              color: AppColors.primaryDark,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            final cubit = context.read<SearchCubit>();
            int totalItemsCount = 0;
            if (state is SearchSuccess) {
              totalItemsCount = state.totalItems;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Filters Form (المحافظة | الوجهة | الشركة | النوع)
                  if (_showFilters) ...[
                    SearchFiltersForm(
                      selectedGovernorate: cubit.selectedGovernorate,
                      selectedDestination: cubit.selectedDestination,
                      selectedCategory: cubit.selectedCategory,
                      selectedCompanyId: cubit.selectedCompanyId,
                      companies: cubit.availableCompanies,
                      onGovernorateChanged: (gov) => cubit.setGovernorate(gov),
                      onDestinationChanged: (dest) =>
                          cubit.setDestination(dest),
                      onCategoryChanged: (cat) => cubit.setCategory(cat),
                      onCompanyChanged: (companyId) =>
                          cubit.setCompany(companyId),
                    ),
                    AppSizes.p24.verticalSpace,

                    // Show Results Button
                    AppButton(
                      text:
                          '${AppStrings.showResults} (${totalItemsCount > 0 ? totalItemsCount : '...'})',
                      onPressed: () => cubit.performSearch(),
                    ),
                    AppSizes.p12.verticalSpace,

                    // Clear Filters Text Button
                    Center(
                      child: TextButton(
                        onPressed: () {
                          cubit.clearFilters();
                          setState(() {});
                        },
                        child: Text(
                          AppStrings.clearAllFilters,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    AppSizes.p16.verticalSpace,
                  ],

                  // Search Results List
                  if (state is SearchLoading) ...[
                    AppSizes.p24.verticalSpace,
                    const Center(child: AppLoading()),
                  ] else if (state is SearchFailure) ...[
                    AppSizes.p24.verticalSpace,
                    Center(
                      child: Text(
                        state.error,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ] else if (state is SearchSuccess) ...[
                    SearchResultsList(trips: state.trips),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
