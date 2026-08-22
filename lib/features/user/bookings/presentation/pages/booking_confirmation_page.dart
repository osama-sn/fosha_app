import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/company_profile/data/datasources/company_profile_remote_data_source.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_payment_account_model.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/user/bookings/presentation/cubit/create_booking_cubit.dart';
import 'package:fosha_app/features/user/bookings/presentation/pages/booking_success_page.dart';
import 'package:fosha_app/features/user/bookings/presentation/widgets/booking_confirmation_header_card.dart';
import 'package:fosha_app/features/user/bookings/presentation/widgets/booking_seats_counter_widget.dart';

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
  int _currentStep = 1;
  int _adultsCount = 2;
  int _childrenCount = 0;
  String _selectedPaymentMethod = 'instapay';
  List<CompanyPaymentAccountModel> _companyPaymentAccounts = [];

  final TextEditingController _senderInstaPayController =
      TextEditingController();
  final TextEditingController _senderNumberController =
      TextEditingController();
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCompanyAccounts();
  }

  Future<void> _fetchCompanyAccounts() async {
    final trip = widget.trip;
    final companyId = trip?.companyId.isNotEmpty == true
        ? trip!.companyId
        : (trip?.company?.id ?? '');

    if (companyId.isNotEmpty) {
      try {
        final accounts = await getIt<CompanyProfileRemoteDataSource>()
            .getPaymentAccounts(companyId);
        if (mounted) {
          setState(() {
            _companyPaymentAccounts =
                accounts.where((a) => a.isActive).toList();
          });
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _senderInstaPayController.dispose();
    _senderNumberController.dispose();
    _couponController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  TripModel _getEffectiveTrip(BuildContext context) {
    if (widget.trip != null) return widget.trip!;
    final extra = GoRouterState.of(context).extra;
    if (extra is TripModel) return extra;

    return const TripModel(
      id: '6a6bb522bcf27f39324162bb',
      title: 'رحلة أسبوعية مميزة',
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
    return basePrice > 0 ? basePrice : 0;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    AppSnackbar.showSuccess(
      context: context,
      message: AppStrings.bookingCopiedToClipboard,
    );
  }

  IconData _getProviderIcon(String provider) {
    switch (provider) {
      case 'instapay':
        return Icons.account_balance_wallet_outlined;
      case 'vodafone_cash':
      case 'orange_cash':
      case 'etisalat_cash':
      case 'wallet':
        return Icons.phone_android_outlined;
      case 'bank_transfer':
        return Icons.account_balance_outlined;
      default:
        return Icons.credit_card_outlined;
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
      case 'bank_transfer':
        return 'تحويل بنكي';
      default:
        return 'محفظة تحويل';
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = _getEffectiveTrip(context);
    final totalPrice = _calculateTotal(trip.price > 0 ? trip.price : 2450.0);
    final companyName = trip.companyName.isNotEmpty
        ? trip.companyName
        : (trip.company?.name.isNotEmpty == true
            ? trip.company!.name
            : AppStrings.userDefaultCompanyName);
    final companyPhone = trip.company?.contactPhone.isNotEmpty == true
        ? trip.company!.contactPhone
        : '+201001234567';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () {
            if (_currentStep == 2) {
              setState(() => _currentStep = 1);
            } else {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.pop();
              }
            }
          },
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentStep == 1 ? AppStrings.step1Title : AppStrings.step2Title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'خطوة $_currentStep من 2',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppStrings.adminTotalRevenue}:',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                      Text(
                        '$totalPrice ${AppStrings.currencyEGP}',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AppButton(
                      text: _currentStep == 1
                          ? AppStrings.nextStepPayment
                          : AppStrings.bookingConfirmedSuccess,
                      onPressed: () {
                        if (_currentStep == 1) {
                          setState(() => _currentStep = 2);
                        } else {
                          context.read<CreateBookingCubit>().createBooking(
                                tripId: trip.id,
                                numberOfSeats: _totalSeats,
                                paymentMethod: _selectedPaymentMethod,
                                paymentSenderInstaPay:
                                    _senderInstaPayController.text.trim(),
                                paymentSenderNumber:
                                    _senderNumberController.text.trim(),
                                pickupPoint: trip.origin,
                                pickupTime: trip.startDate,
                                couponCode: _couponController.text.trim(),
                                notes: _notesController.text.trim(),
                              );
                        }
                      },
                    ),
                  ),
                ],
              ),
              if (_currentStep == 2) ...[
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: () => setState(() => _currentStep = 1),
                  child: Text(
                    AppStrings.previousStep,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
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
            AppSnackbar.showError(
              context: context,
              message: state.error,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p16),
              child: _currentStep == 1
                  ? _buildStep1(trip, companyName, companyPhone)
                  : _buildStep2(trip),
            ),
          );
        },
      ),
    );
  }

  // STEP 1: Select seats, method, and COPY company account
  Widget _buildStep1(TripModel trip, String companyName, String companyPhone) {
    final activeAccounts = _companyPaymentAccounts.isNotEmpty
        ? _companyPaymentAccounts
        : (trip.company?.paymentAccounts.where((a) => a.isActive).toList() ??
            []);

    return Column(
      key: const ValueKey(1),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingConfirmationHeaderCard(trip: trip),
        AppSizes.p16.verticalSpace,

        // Seats Counter Card
        Container(
          padding: EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.adminSeatsCount,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSizes.p12.verticalSpace,
              BookingSeatsCounterWidget(
                title: AppStrings.adminPersonUnit,
                subtitle: AppStrings.perPerson,
                count: _adultsCount,
                onChanged: (val) {
                  if (val >= 1) setState(() => _adultsCount = val);
                },
              ),
              const Divider(color: AppColors.border),
              BookingSeatsCounterWidget(
                title: AppStrings.childrenLabel,
                subtitle: 'خصم 30%',
                count: _childrenCount,
                onChanged: (val) {
                  if (val >= 0) setState(() => _childrenCount = val);
                },
              ),
            ],
          ),
        ),
        AppSizes.p16.verticalSpace,

        // Select Payment Method
        Container(
          padding: EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.adminPaymentMethodLabel,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSizes.p12.verticalSpace,
              DropdownButtonFormField<String>(
                initialValue: _selectedPaymentMethod,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'instapay', child: Text('InstaPay')),
                  DropdownMenuItem(
                      value: 'vodafone_cash', child: Text('Vodafone Cash')),
                  DropdownMenuItem(
                      value: 'bank', child: Text('تحويل بنكي')),
                  DropdownMenuItem(
                      value: 'cash', child: Text('نقداً عند اللقاء')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedPaymentMethod = val);
                  }
                },
              ),
            ],
          ),
        ),
        AppSizes.p16.verticalSpace,

        // STEP 1 Copyable Company Target Accounts Card
        Container(
          padding: EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.primaryDark,
                    size: 22.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '${AppStrings.companyTransferDetailsTitle} ($companyName)',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                AppStrings.companyTransferPhoneNotice,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (activeAccounts.isNotEmpty) ...[
                for (final account in activeAccounts) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _getProviderIcon(account.provider),
                                    size: 16.r,
                                    color: AppColors.primaryDark,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    account.title.isNotEmpty
                                        ? account.title
                                        : _getProviderLabel(account.provider),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.textHint,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                account.displayAddress,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              if (account.instructions.isNotEmpty) ...[
                                SizedBox(height: 2.h),
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
                        InkWell(
                          onTap: () =>
                              _copyToClipboard(account.displayAddress),
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.copy,
                                    size: 14.r, color: Colors.white),
                                SizedBox(width: 4.w),
                                Text(
                                  AppStrings.copyCompanyAccount,
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
                ],
              ] else ...[
                SizedBox(height: 8.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          companyPhone,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _copyToClipboard(companyPhone),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.copy, size: 14.r, color: Colors.white),
                              SizedBox(width: 4.w),
                              Text(
                                AppStrings.copyCompanyAccount,
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
              ],
              SizedBox(height: 10.h),
              Text(
                AppStrings.companyTransferConfirmationNotice,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textHint,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 2: Input user sender account/phone & optional details & confirm
  Widget _buildStep2(TripModel trip) {
    return Column(
      key: const ValueKey(2),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Sender Details Input Card
        Container(
          padding: EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'بيانات التحويل الخاصة بك (الحساب المحول منه)',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSizes.p12.verticalSpace,
              if (_selectedPaymentMethod == 'instapay') ...[
                TextField(
                  controller: _senderInstaPayController,
                  decoration: InputDecoration(
                    labelText: 'حساب انستا باي الخاص بك المحول منه',
                    hintText: 'yourname@instapay',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                AppSizes.p12.verticalSpace,
              ],
              TextField(
                controller: _senderNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف الخاص بك المحول منه',
                  hintText: '01012345678',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSizes.p16.verticalSpace,

        // Coupon & Notes Card
        Container(
          padding: EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.adminNotesPrefix,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSizes.p8.verticalSpace,
              TextField(
                controller: _couponController,
                decoration: InputDecoration(
                  labelText: 'كود الخصم (إن وجد)',
                  hintText: 'SUMMER2026',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              AppSizes.p12.verticalSpace,
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: AppStrings.adminExpenseNotesHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
