import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/router/route_names.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_text_field.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/user/home/presentation/cubit/home_cubit.dart';
import 'package:fosha_app/features/user/home/presentation/cubit/home_state.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/home_categories_widget.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/home_featured_banner_widget.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/home_featured_companies_widget.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/home_header_widget.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/home_popular_destinations_widget.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/home_promo_banner_widget.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => getIt<HomeCubit>()..fetchHomeData(governorate: 'المنيا'),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          if (state is HomeLoading) {
            return const Center(child: AppLoading());
          }

          if (state is HomeFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: AppColors.error, size: 48.r),
                    AppSizes.p16.verticalSpace,
                    Text(
                      AppStrings.errorOccurred,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSizes.p8.verticalSpace,
                    Text(
                      state.error,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSizes.p24.verticalSpace,
                    AppButton(
                      text: AppStrings.retry,
                      onPressed: () => cubit.fetchHomeData(),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is HomeSuccess) {
            final data = state.homeData;

            return RefreshIndicator(
              onRefresh: () => cubit.fetchHomeData(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeHeaderWidget(
                      currentGovernorate: data.userGovernorate.isNotEmpty
                          ? data.userGovernorate
                          : cubit.currentGovernorate,
                      onGovernorateChanged: (gov) =>
                          cubit.changeGovernorate(gov),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                      child: GestureDetector(
                        onTap: () => context.push(RouteNames.search),
                        child: AbsorbPointer(
                          child: AppTextField(
                            hintText: 'ابحث عن رحلة، وجهة، شركة...',
                            type: AppTextFieldType.search,
                          ),
                        ),
                      ),
                    ),
                    AppSizes.p16.verticalSpace,
                    HomeFeaturedBannerWidget(trips: data.featuredTrips),
                    AppSizes.p16.verticalSpace,
                    HomeCategoriesWidget(
                      categories: data.categories,
                      onCategorySelected: (cat) {
                        context.push(
                          RouteNames.categoryTrips,
                          extra: cat,
                        );
                      },
                      onViewAll: () => context.push(RouteNames.search),
                    ),
                    AppSizes.p16.verticalSpace,
                    HomePopularDestinationsWidget(
                      trips: data.governorateTrips,
                      title: 'رحلات محافظة ${data.userGovernorate}',
                      onViewAll: () => context.push(RouteNames.search),
                    ),
                    AppSizes.p16.verticalSpace,
                    HomePromoBannerWidget(offers: data.offers),
                    AppSizes.p16.verticalSpace,
                    HomeFeaturedCompaniesWidget(
                      companies: data.featuredCompanies,
                    ),
                    AppSizes.p20.verticalSpace,
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
