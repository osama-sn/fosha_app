import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/dashboard/data/repositories/admin_dashboard_stats_repository.dart';
import 'package:fosha_app/features/admin/reviews/data/models/company_review_model.dart';
import 'package:fosha_app/features/admin/reviews/presentation/cubit/admin_reviews_cubit.dart';

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
          'التقييمات وآراء العملاء',
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
                    // Rating Header Summary Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                data.averageRating.toStringAsFixed(1),
                                style: AppTextStyles.headlineLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade700,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < data.averageRating.floor()
                                        ? Icons.star
                                        : (index < data.averageRating
                                            ? Icons.star_half
                                            : Icons.star_border),
                                    color: Colors.amber,
                                    size: 18.r,
                                  );
                                }),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'إجمالي ${data.totalReviews} تقييم',
                                style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 11.sp),
                              ),
                            ],
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'انطباعات العملاء',
                                  style: AppTextStyles.titleSmall.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'تساعد التقييمات العالية في تحسين ترتيب رحلات شركتك في نتائج البحث.',
                                  style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 11.sp),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Text(
                      'أحدث التقييمات',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    if (data.reviews.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Center(
                          child: Text(
                            'لا توجد تقييمات مسجلة بعد للشركة',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.reviews.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final review = data.reviews[index];
                          return _buildReviewCard(review);
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

  Widget _buildReviewCard(CompanyReviewModel review) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    review.user.fullName.isNotEmpty
                        ? review.user.fullName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.user.fullName,
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (review.tripTitle != null &&
                          review.tripTitle!.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          'رحلة: ${review.tripTitle}',
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.primaryDark),
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    SizedBox(width: 4.w),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Text(
                review.comment,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
