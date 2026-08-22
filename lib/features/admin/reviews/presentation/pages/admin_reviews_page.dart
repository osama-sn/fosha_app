import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/dashboard/data/repositories/admin_dashboard_stats_repository.dart';
import 'package:fosha_app/features/admin/reviews/presentation/cubit/admin_reviews_cubit.dart';
import 'package:fosha_app/features/admin/reviews/presentation/widgets/admin_review_card.dart';
import 'package:fosha_app/features/admin/reviews/presentation/widgets/admin_reviews_empty_view.dart';
import 'package:fosha_app/features/admin/reviews/presentation/widgets/admin_reviews_summary_card.dart';

class AdminReviewsPage extends StatefulWidget {
  final String? companyId;

  const AdminReviewsPage({super.key, this.companyId});

  @override
  State<AdminReviewsPage> createState() => _AdminReviewsPageState();
}

class _AdminReviewsPageState extends State<AdminReviewsPage> {
  String? _companyId;

  @override
  void initState() {
    super.initState();
    _initCompanyId();
  }

  Future<void> _initCompanyId() async {
    if (widget.companyId != null && widget.companyId!.isNotEmpty) {
      _companyId = widget.companyId;
    } else {
      try {
        final repo = getIt<AdminDashboardStatsRepository>();
        final stats = await repo.getDashboardStats();
        stats.fold(
          (_) {},
          (data) {
            _companyId = data.company?.id;
          },
        );
      } catch (_) {}
    }

    if (mounted) {
      context
          .read<AdminReviewsCubit>()
          .fetchCompanyReviews(_companyId ?? 'me');
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
          AppStrings.adminReviewsTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AdminReviewsCubit, AdminReviewsState>(
        builder: (context, state) {
          if (state is AdminReviewsLoading) {
            return const Center(child: AppLoading());
          }

          if (state is AdminReviewsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          if (state is AdminReviewsLoaded) {
            final data = state.data;
            return RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<AdminReviewsCubit>()
                    .fetchCompanyReviews(_companyId ?? 'me');
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminReviewsSummaryCard(
                      averageRating: data.averageRating,
                      totalReviews: data.totalReviews,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      AppStrings.adminLatestReviews,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if (data.reviews.isEmpty)
                      const AdminReviewsEmptyView()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.reviews.length,
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final review = data.reviews[index];
                          return AdminReviewCard(review: review);
                        },
                      ),
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
