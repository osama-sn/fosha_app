import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/features/user/favorites/data/repositories/favorites_repository.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/trip_company_card.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/trip_details_features_grid.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/trip_details_header_info.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/trip_details_included_excluded.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/trip_details_places_to_visit.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/trip_details_reviews.dart';
import 'package:fosha_app/features/user/home/presentation/widgets/trip_details_sticky_footer.dart';

class TripDetailsPage extends StatefulWidget {
  final TripModel? trip;

  const TripDetailsPage({super.key, this.trip});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  int _selectedDayIndex = 0;
  bool? _isFavorite;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 200 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  TripModel _getEffectiveTrip(BuildContext context) {
    if (widget.trip != null) return widget.trip!;
    final extra = GoRouterState.of(context).extra;
    if (extra is TripModel) return extra;

    // Fallback default trip object
    return const TripModel(
      id: 'default_id',
      title: 'شرم الشيخ - رحلة استجمام 5 أيام',
      description:
          'استمتع برحلة استجمام لا تُنسى في مدينة شرم الشيخ. إقامة في أفضل المنتجعات على البحر الأحمر مع جولات بحرية وزيارة أهم الأماكن السياحية.',
      origin: 'القاهرة',
      destination: 'شرم الشيخ',
      price: 2450.0,
      capacity: 30,
      availableSeats: 15,
      startDate: '2026-05-15T00:00:00.000Z',
      endDate: '2026-05-20T00:00:00.000Z',
      status: 'published',
      createdBySystem: false,
      isProtected: true,
      coverImage: '',
      gallery: [],
      included: [
        'الإقامة في فندق 5 نجوم',
        'وجبة الإفطار يومياً',
        'المواصلات والتنقلات',
        'رحلات وجولات سياحية',
        'دليل سياحي',
      ],
      excluded: ['تذاكر الطيران', 'الوجبات غير المذكورة', 'المصاريف الشخصية'],
      cancelPolicy: '',
      averageRating: 4.8,
      reviewsCount: 125,
      days: [],
      createdAt: '',
      updatedAt: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = _getEffectiveTrip(context);
    _isFavorite ??= trip.isFavorite;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: TripDetailsStickyFooter(trip: trip),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(trip),
          SliverToBoxAdapter(child: _buildBody(trip)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(TripModel trip) {
    final gallery = trip.galleryWithBaseUrl;
    final isFav = _isFavorite ?? trip.isFavorite;

    return SliverAppBar(
      expandedHeight: 320.h,
      pinned: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: _isScrolled
                ? Colors.transparent
                : Colors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back,
            color: _isScrolled ? AppColors.textPrimary : Colors.white,
          ),
        ),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            context.pop();
          }
        },
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: _isScrolled
                  ? Colors.transparent
                  : Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav
                  ? Colors.red
                  : (_isScrolled ? AppColors.textPrimary : Colors.white),
            ),
          ),
          onPressed: () async {
            final trip = _getEffectiveTrip(context);
            final currentFav = _isFavorite ?? trip.isFavorite;
            setState(() {
              _isFavorite = !currentFav;
            });
            try {
              final repo = getIt<FavoritesRepository>();
              final isFavResult = await repo.toggleFavorite(trip.id);
              isFavResult.fold(
                (_) {
                  setState(() {
                    _isFavorite = currentFav;
                  });
                },
                (isFav) {
                  setState(() {
                    _isFavorite = isFav;
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFav
                              ? 'تمت إضافة الرحلة للمفضلة ❤️'
                              : 'تمت إزالة الرحلة من المفضلة',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              );
            } catch (_) {}
          },
        ),
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: _isScrolled
                  ? Colors.transparent
                  : Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.ios_share,
              color: _isScrolled ? AppColors.textPrimary : Colors.white,
            ),
          ),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(
              imageUrl: trip.fullCoverImageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 24.h,
              left: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.collections, color: Colors.white, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '1/${gallery.isNotEmpty ? gallery.length : 18}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(TripModel trip) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      transform: Matrix4.translationValues(0.0, -20.h, 0.0),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gallery Thumbnails strip if available
            if (trip.galleryWithBaseUrl.isNotEmpty) ...[
              SizedBox(
                height: 60.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: trip.galleryWithBaseUrl.length,
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: index == 0
                              ? AppColors.primary
                              : AppColors.border,
                          width: index == 0 ? 2 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: AppNetworkImage(
                          imageUrl: trip.galleryWithBaseUrl[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              AppSizes.p16.verticalSpace,
            ],

            // 1. Header Info (Title, Rating, Category, Price)
            TripDetailsHeaderInfo(trip: trip),
            AppSizes.p16.verticalSpace,

            // 2. Quick Info Grid (4 Cards)
            TripDetailsFeaturesGrid(trip: trip),
            AppSizes.p20.verticalSpace,

            // 3. عن الرحلة (Description)
            Text(
              'عن الرحلة',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            AppSizes.p8.verticalSpace,
            Text(
              trip.description.isNotEmpty
                  ? trip.description
                  : 'استمتع برحلة استجمام لا تُنسى في مدينة شرم الشيخ. إقامة في أفضل المنتجعات على البحر الأحمر مع جولات بحرية وزيارة أهم الأماكن السياحية.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            AppSizes.p4.verticalSpace,
            GestureDetector(
              onTap: () {},
              child: Text(
                'عرض المزيد',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppSizes.p20.verticalSpace,

            // 4. الأماكن التي ستزورها (Places to visit)
            TripDetailsPlacesToVisit(
              places: trip.days.isNotEmpty
                  ? trip.days
                        .expand((d) => d.activities.map((a) => a.location))
                        .where((loc) => loc.isNotEmpty)
                        .toSet()
                        .toList()
                  : const ['خليج نعمة', 'رأس محمد', 'جزيرة تيران', 'محمية نبق'],
            ),
            AppSizes.p20.verticalSpace,

            // 5. البرنامج اليومي (Itinerary Accordion)
            Text(
              'البرنامج اليومي',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            AppSizes.p12.verticalSpace,
            _buildItinerarySection(trip),
            AppSizes.p20.verticalSpace,

            // 6. ماذا يشمل السعر / ماذا لا يشمل السعر
            TripDetailsIncludedExcluded(
              included: trip.included.isNotEmpty
                  ? trip.included
                  : const [
                      'الإقامة في فندق 5 نجوم',
                      'وجبة الإفطار يومياً',
                      'المواصلات والتنقلات',
                      'رحلات وجولات سياحية',
                      'دليل سياحي',
                    ],
              excluded: trip.excluded.isNotEmpty
                  ? trip.excluded
                  : const [
                      'تذاكر الطيران',
                      'الوجبات غير المذكورة',
                      'المصاريف الشخصية',
                    ],
            ),
            AppSizes.p20.verticalSpace,

            // 7. تقييمات الرحلة (Reviews)
            TripDetailsReviews(
              averageRating: trip.averageRating > 0 ? trip.averageRating : 4.8,
              reviewsCount: trip.reviewsCount > 0 ? trip.reviewsCount : 125,
            ),
            AppSizes.p20.verticalSpace,

            // 8. معلومات الشركة (Company Info Card)
            TripCompanyCard(
              company: trip.company,
              companyId: trip.companyId,
              companyName: trip.companyName,
              companyLogo: trip.companyLogo,
            ),
            AppSizes.p32.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildItinerarySection(TripModel trip) {
    if (trip.days.isEmpty) {
      return Column(
        children: [
          _buildDayAccordion(
            dayIndex: 0,
            title: 'اليوم 1: الوصول والاستقبال - جولة خليج نعمة',
            activities: [
              '10:00 AM - الوصول لدهب والتسكين بفندق دهب بلازا',
              '03:00 PM - جولة حرة واستكشاف الأسواق',
            ],
          ),
          AppSizes.p8.verticalSpace,
          _buildDayAccordion(
            dayIndex: 1,
            title: 'اليوم 2: رحلة بحرية - جزيرة تيران',
            activities: [
              '09:00 AM - التحرك إلى اليخت لبدء الرحلة البحرية',
              '01:00 PM - تناول وجبة الغداء الساخنة على اليخت',
            ],
          ),
        ],
      );
    }

    return Column(
      children: List.generate(trip.days.length, (index) {
        final day = trip.days[index];
        final actsList = day.activities
            .map((a) => '${a.time.isNotEmpty ? "${a.time} - " : ""}${a.title}')
            .toList();

        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _buildDayAccordion(
            dayIndex: index,
            title: 'اليوم ${day.dayNumber}: ${day.title}',
            activities: actsList,
          ),
        );
      }),
    );
  }

  Widget _buildDayAccordion({
    required int dayIndex,
    required String title,
    required List<String> activities,
  }) {
    final isExpanded = _selectedDayIndex == dayIndex;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        key: Key('day_$dayIndex'),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          if (expanded) {
            setState(() => _selectedDayIndex = dayIndex);
          }
        },
        tilePadding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: activities.map((act) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        size: 8.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          act,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
