import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/create_booking_cubit.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/create_booking_state.dart';
import 'package:fosha_app/features/user/bookings/presentation/pages/booking_success_page.dart';

class BookingConfirmationPage extends StatelessWidget {
  final TripModel? trip;

  const BookingConfirmationPage({super.key, this.trip});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateBookingCubit>(
      create: (context) => getIt<CreateBookingCubit>(),
      child: _BookingConfirmationBody(trip: trip),
    );
  }
}

class _BookingConfirmationBody extends StatefulWidget {
  final TripModel? trip;

  const _BookingConfirmationBody({this.trip});

  @override
  State<_BookingConfirmationBody> createState() =>
      __BookingConfirmationBodyState();
}

class __BookingConfirmationBodyState extends State<_BookingConfirmationBody> {
  int _adultsCount = 2;
  int _childrenCount = 0;
  int _infantsCount = 0;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _promoCodeController = TextEditingController();
  double _discountAmount = 0.0;
  String? _appliedPromo;

  @override
  void dispose() {
    _notesController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  TripModel _getEffectiveTrip(BuildContext context) {
    if (widget.trip != null) return widget.trip!;
    final extra = GoRouterState.of(context).extra;
    if (extra is TripModel) return extra;

    return const TripModel(
      id: '6a6bb522bcf27f39324162bb',
      title: 'شرم الشيخ - رحلة استجمام',
      description: '',
      origin: 'القاهرة',
      destination: 'شرم الشيخ',
      price: 2450.0,
      capacity: 30,
      availableSeats: 20,
      startDate: '2026-08-15T00:00:00.000Z',
      endDate: '2026-08-19T00:00:00.000Z',
      status: 'published',
      createdBySystem: false,
      isProtected: true,
      coverImage: '',
      gallery: [],
      included: [],
      excluded: [],
      cancelPolicy: '',
      averageRating: 4.8,
      reviewsCount: 125,
      days: [],
      createdAt: '',
      updatedAt: '',
    );
  }

  int get _totalSeats => _adultsCount + _childrenCount;

  double _calculateTotal(double pricePerSeat) {
    final basePrice =
        (_adultsCount * pricePerSeat) + (_childrenCount * (pricePerSeat * 0.7));
    return (basePrice - _discountAmount) > 0
        ? (basePrice - _discountAmount)
        : 0;
  }

  void _applyPromo(double pricePerSeat) {
    final code = _promoCodeController.text.trim();
    if (code.toUpperCase() == 'SUMMER10' || code.toUpperCase() == 'SUMMER20') {
      setState(() {
        _appliedPromo = code.toUpperCase();
        _discountAmount = 665.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تطبيق كود الخصم $_appliedPromo بنجاح!')),
      );
    } else if (code.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كود الخصم غير صحيح أو منتهي الصلاحية')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = _getEffectiveTrip(context);
    final totalPrice = _calculateTotal(trip.price > 0 ? trip.price : 2450.0);

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
        title: Column(
          children: [
            Text(
              'حجز الرحلة',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 12.r,
                  color: AppColors.textHint,
                ),
                SizedBox(width: 4.w),
                Text(
                  'بياناتك محمية وآمنة',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CreateBookingCubit, CreateBookingState>(
        listener: (context, state) {
          if (state is CreateBookingSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    BookingSuccessPage(booking: state.booking),
              ),
            );
          } else if (state is CreateBookingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip Summary Card
                  Container(
                    padding: EdgeInsets.all(AppSizes.p12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: SizedBox(
                            width: 80.w,
                            height: 80.w,
                            child: AppNetworkImage(
                              imageUrl: trip.fullCoverImageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip.title,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                trip.durationText.isNotEmpty
                                    ? trip.durationText
                                    : '${trip.origin} ➔ ${trip.destination}',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${trip.price > 0 ? trip.price.toStringAsFixed(0) : '2,450'} ج.م / للشخص',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSizes.p20.verticalSpace,

                  // عدد الأفراد Section
                  Text(
                    'عدد الأفراد',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.p12.verticalSpace,
                  Container(
                    padding: EdgeInsets.all(AppSizes.p16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildCounterRow(
                          title: 'البالغون (12 سنة فأكثر)',
                          count: _adultsCount,
                          onIncrement: () => setState(() => _adultsCount++),
                          onDecrement: () {
                            if (_adultsCount > 1) {
                              setState(() => _adultsCount--);
                            }
                          },
                        ),
                        const Divider(color: AppColors.border, height: 24),
                        _buildCounterRow(
                          title: 'الأطفال (من 6 - 11 سنة)',
                          count: _childrenCount,
                          onIncrement: () => setState(() => _childrenCount++),
                          onDecrement: () {
                            if (_childrenCount > 0) {
                              setState(() => _childrenCount--);
                            }
                          },
                        ),
                        const Divider(color: AppColors.border, height: 24),
                        _buildCounterRow(
                          title: 'الأطفال (أقل من 6 سنوات)',
                          count: _infantsCount,
                          onIncrement: () => setState(() => _infantsCount++),
                          onDecrement: () {
                            if (_infantsCount > 0) {
                              setState(() => _infantsCount--);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  AppSizes.p20.verticalSpace,

                  // ملاحظات إضافية
                  Text(
                    'ملاحظات إضافية',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.p8.verticalSpace,
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'اكتب أي ملاحظات أو طلبات خاصة (اختياري) مثل: يرجى توفير غرفتين متجاورين',
                      hintStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  AppSizes.p20.verticalSpace,

                  // كوبون خصم
                  Text(
                    'كوبون خصم',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.p8.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _promoCodeController,
                          decoration: InputDecoration(
                            hintText: 'أدخل كود الخصم',
                            hintStyle: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textHint,
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSizes.p12,
                              vertical: 12.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: Colors.white,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () =>
                              _applyPromo(trip.price > 0 ? trip.price : 2450.0),
                          child: Text(
                            'تطبيق',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSizes.p20.verticalSpace,

                  // ملخص السعر
                  Text(
                    'ملخص السعر',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSizes.p8.verticalSpace,
                  Container(
                    padding: EdgeInsets.all(AppSizes.p16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow(
                          '$_adultsCount بالغ × ${(trip.price > 0 ? trip.price : 2450.0).toStringAsFixed(0)} ج.م',
                          '${(_adultsCount * (trip.price > 0 ? trip.price : 2450.0)).toStringAsFixed(0)} ج.م',
                        ),
                        if (_childrenCount > 0) ...[
                          AppSizes.p8.verticalSpace,
                          _buildPriceRow(
                            '$_childrenCount طفل × ${((trip.price > 0 ? trip.price : 2450.0) * 0.7).toStringAsFixed(0)} ج.م',
                            '${(_childrenCount * (trip.price > 0 ? trip.price : 2450.0) * 0.7).toStringAsFixed(0)} ج.م',
                          ),
                        ],
                        if (_discountAmount > 0) ...[
                          AppSizes.p8.verticalSpace,
                          _buildPriceRow(
                            'خصم (كوبون $_appliedPromo)',
                            '- ${_discountAmount.toStringAsFixed(0)} ج.م',
                            isDiscount: true,
                          ),
                        ],
                        const Divider(color: AppColors.border, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الإجمالي النهائي',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${totalPrice.toStringAsFixed(0)} ج.م',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSizes.p24.verticalSpace,

                  // Action Button
                  if (state is CreateBookingLoading)
                    const Center(child: AppLoading())
                  else
                    AppButton(
                      text: 'متابعة الدفع (تأكيد الحجز)',
                      onPressed: () {
                        context.read<CreateBookingCubit>().createBooking(
                          tripId: trip.id,
                          numberOfSeats: _totalSeats,
                          notes: _notesController.text,
                        );
                      },
                    ),
                  AppSizes.p24.verticalSpace,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCounterRow({
    required String title,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(
                  Icons.remove,
                  size: 16.r,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            SizedBox(
              width: 28.w,
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                  color: AppColors.primaryDark,
                ),
                child: Icon(Icons.add, size: 16.r, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isDiscount ? Colors.green : AppColors.textSecondary,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: isDiscount ? Colors.green : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
