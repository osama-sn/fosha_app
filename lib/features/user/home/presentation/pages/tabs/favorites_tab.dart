import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/user/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:fosha_app/features/user/search/presentation/widgets/search_results_list.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesCubit>(
      create: (context) => getIt<FavoritesCubit>()..loadFavorites(),
      child: const _FavoritesTabBody(),
    );
  }
}

class _FavoritesTabBody extends StatefulWidget {
  const _FavoritesTabBody();

  @override
  State<_FavoritesTabBody> createState() => _FavoritesTabBodyState();
}

class _FavoritesTabBodyState extends State<_FavoritesTabBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesCubit>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.favoritesTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: AppLoading());
          }

          if (state is FavoritesFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 48.r,
                    ),
                    AppSizes.p16.verticalSpace,
                    Text(
                      state.error,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSizes.p24.verticalSpace,
                    AppButton(
                      text: AppStrings.retry,
                      onPressed: () =>
                          context.read<FavoritesCubit>().loadFavorites(),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.p24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        size: 64.r,
                        color: AppColors.textHint,
                      ),
                      AppSizes.p16.verticalSpace,
                      Text(
                        AppStrings.favoritesEmpty,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p8.verticalSpace,
                      Text(
                        AppStrings.favoritesEmptySub,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<FavoritesCubit>().loadFavorites(),
              child: ListView.separated(
                padding: EdgeInsets.all(AppSizes.p16),
                itemCount: state.favorites.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppSizes.p12),
                itemBuilder: (context, index) {
                  final trip = state.favorites[index];
                  return Stack(
                    children: [
                      SearchTripCard(trip: trip),
                      Positioned(
                        top: 12.h,
                        left: 12.w,
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<FavoritesCubit>()
                                .toggleFavorite(trip.id);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20.r,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
