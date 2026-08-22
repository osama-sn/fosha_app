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
import 'package:dartz/dartz.dart' hide State;
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_review_model.dart';
import 'package:fosha_app/features/admin/company_profile/data/repositories/company_profile_repository.dart';
import 'package:fosha_app/features/admin/company_profile/presentation/cubit/company_profile_cubit.dart';
import 'package:fosha_app/features/admin/trips/data/models/paginated_trips_model.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/user/company/presentation/widgets/company_contact_info_widget.dart';
import 'package:fosha_app/features/user/company/presentation/widgets/company_header_cover_widget.dart';
import 'package:fosha_app/features/user/company/presentation/widgets/company_stats_bar_widget.dart';
import 'package:fosha_app/features/user/search/data/repositories/search_repository.dart';
import 'package:fosha_app/features/user/search/presentation/widgets/search_results_list.dart';
import 'package:fosha_app/features/chat/presentation/pages/chat_page.dart';

class CompanyDetailsPage extends StatelessWidget {
  final String? companyId;

  const CompanyDetailsPage({super.key, this.companyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompanyProfileCubit>(
      create: (context) =>
          getIt<CompanyProfileCubit>()..loadCompanyProfile(companyId!),
      child: _CompanyDetailsBody(companyId: companyId!),
    );
  }
}

class _CompanyDetailsBody extends StatefulWidget {
  final String companyId;

  const _CompanyDetailsBody({required this.companyId});

  @override
  State<_CompanyDetailsBody> createState() => _CompanyDetailsBodyState();
}

class _CompanyDetailsBodyState extends State<_CompanyDetailsBody> {
  int _selectedTab = 0; // 0: نبذة, 1: الرحلات, 2: التقييمات, 3: المعلومات
  int? _tripsCount;

  @override
  void initState() {
    super.initState();
    _fetchTripsCount();
  }

  Future<void> _fetchTripsCount() async {
    try {
      final result = await getIt<SearchRepository>().searchTrips(
        companyId: widget.companyId,
        limit: 1,
      );
      result.fold(
        (_) {},
        (res) {
          if (mounted) {
            setState(() {
              _tripsCount = res.totalItems;
            });
          }
        },
      );
    } catch (_) {}
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
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          AppStrings.companyDetailsTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar:
          BlocBuilder<CompanyProfileCubit, CompanyProfileState>(
        builder: (context, state) {
          CompanyProfileModel? profile;
          if (state is CompanyProfileLoaded) {
            profile = state.profile;
          }
          final phone = profile?.contactPhone ?? '+201011111111';

          return Container(
            padding: EdgeInsets.all(AppSizes.p16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10.r,
                  offset: Offset(0, -4.h),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        companyId: widget.companyId,
                        companyName:
                            profile?.name ?? AppStrings.userDefaultCompanyName,
                        companyPhone: phone,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(
                  AppStrings.contactWithCompany,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      body: BlocBuilder<CompanyProfileCubit, CompanyProfileState>(
        builder: (context, state) {
          if (state is CompanyProfileLoading) {
            return const Center(child: AppLoading());
          }

          if (state is CompanyProfileFailure) {
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
                      onPressed: () => context
                          .read<CompanyProfileCubit>()
                          .loadCompanyProfile(widget.companyId),
                    ),
                  ],
                ),
              ),
            );
          }

          CompanyProfileModel? profile;
          if (state is CompanyProfileLoaded) {
            profile = state.profile;
          }

          final companyName = profile?.name.isNotEmpty == true
              ? profile!.name
              : AppStrings.userDefaultCompanyName;
          final companyDesc = profile?.description ?? '';
          final rating =
              (profile?.averageRating != null && profile!.averageRating! > 0)
                  ? profile.averageRating!
                  : 4.7;
          final reviewsCount = profile?.reviewsCount ?? 0;

          return SingleChildScrollView(
            child: Column(
              children: [
                CompanyHeaderCoverWidget(profile: profile),
                AppSizes.p12.verticalSpace,

                // Company Name & Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      companyName,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(Icons.verified, color: AppColors.primary, size: 20.r),
                  ],
                ),
                AppSizes.p4.verticalSpace,
                Text(
                  AppStrings.companyTourismType,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSizes.p6.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: AppColors.secondary, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '($reviewsCount ${AppStrings.adminReviewUnit})',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
                AppSizes.p16.verticalSpace,

                // Stats Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  child: CompanyStatsBarWidget(
                    tripsCount: _tripsCount,
                    reviewsCount: reviewsCount,
                    governorate: profile?.governorate,
                  ),
                ),
                AppSizes.p20.verticalSpace,

                // Tab Selector
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTabItem(0, AppStrings.companyTabAbout),
                      _buildTabItem(1, AppStrings.companyTabTrips),
                      _buildTabItem(
                          2, '${AppStrings.companyTabReviews} ($reviewsCount)'),
                      _buildTabItem(3, AppStrings.companyTabInfo),
                    ],
                  ),
                ),
                AppSizes.p16.verticalSpace,

                // Tab Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  child: _buildTabContent(profile, companyDesc),
                ),
                AppSizes.p24.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primaryDark : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? AppColors.primaryDark
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(CompanyProfileModel? profile, String companyDesc) {
    if (_selectedTab == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (companyDesc.isNotEmpty)
            Text(
              companyDesc,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          AppSizes.p20.verticalSpace,
          Text(
            AppStrings.companyContactInfo,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          AppSizes.p12.verticalSpace,
          CompanyContactInfoWidget(profile: profile),
        ],
      );
    } else if (_selectedTab == 1) {
      return FutureBuilder<Either<Failure, PaginatedTripsModel>>(
        future: getIt<SearchRepository>().searchTrips(
          companyId: widget.companyId,
          limit: 20,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoading());
          }
          final trips =
              snapshot.data?.fold((l) => <TripModel>[], (r) => r.trips) ?? [];
          if (trips.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p20),
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_bus_outlined,
                      size: 48.r,
                      color: AppColors.textHint,
                    ),
                    AppSizes.p8.verticalSpace,
                    Text(
                      AppStrings.noTripsAvailableForCompany,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trips.length,
            separatorBuilder: (context, index) => SizedBox(height: AppSizes.p12),
            itemBuilder: (context, index) {
              return SearchTripCard(trip: trips[index]);
            },
          );
        },
      );
    } else if (_selectedTab == 2) {
      return FutureBuilder<Either<Failure, List<CompanyReviewModel>>>(
        future: getIt<CompanyProfileRepository>().getCompanyReviews(
          widget.companyId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoading());
          }
          final reviews =
              snapshot.data?.fold((l) => <CompanyReviewModel>[], (r) => r) ?? [];
          if (reviews.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p20),
                child: Column(
                  children: [
                    Icon(
                      Icons.star_outline,
                      size: 48.r,
                      color: AppColors.textHint,
                    ),
                    AppSizes.p8.verticalSpace,
                    Text(
                      AppStrings.noReviewsForCompany,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: reviews.map((rev) {
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16.r,
                              backgroundColor: AppColors.primaryLight
                                  .withValues(alpha: 0.2),
                              child: Icon(
                                Icons.person,
                                color: AppColors.primaryDark,
                                size: 16.r,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rev.user.fullName,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  rev.createdAt,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textHint,
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              size: 14.sp,
                              color: index < rev.rating
                                  ? AppColors.secondary
                                  : AppColors.border,
                            );
                          }),
                        ),
                      ],
                    ),
                    AppSizes.p8.verticalSpace,
                    Text(
                      rev.comment,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            CompanyContactInfoWidget(profile: profile),
          ],
        ),
      );
    }
  }
}
