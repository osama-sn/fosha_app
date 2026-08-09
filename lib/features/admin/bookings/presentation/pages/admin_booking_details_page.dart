import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_assets.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_bottom_action_bar.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_customer_card.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_customer_notes_card.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_financial_details_card.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_status_banner.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_trip_card.dart';

class AdminBookingDetailsPage extends StatefulWidget {
  final BookingModel? booking;
  final Map<String, dynamic>? bookingData;

  const AdminBookingDetailsPage({
    super.key,
    this.booking,
    this.bookingData,
  });

  @override
  State<AdminBookingDetailsPage> createState() =>
      _AdminBookingDetailsPageState();
}

class _AdminBookingDetailsPageState extends State<AdminBookingDetailsPage> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus =
        widget.booking?.status ?? widget.bookingData?['status'] ?? 'accepted';
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final data = widget.bookingData;

    final customerName = (b?.customerName.isNotEmpty == true)
        ? b!.customerName
        : (data?['customerName']?.toString().isNotEmpty == true
            ? data!['customerName'].toString()
            : (data?['user']?['fullName']?.toString() ?? 'عميل'));

    final customerEmail = (b?.customerEmail.isNotEmpty == true)
        ? b!.customerEmail
        : (data?['customerEmail']?.toString() ??
            data?['user']?['email']?.toString() ??
            '');

    final customerPhone = (b?.customerPhone.isNotEmpty == true)
        ? b!.customerPhone
        : (data?['customerPhone']?.toString() ??
            data?['user']?['phone']?.toString() ??
            '');

    final tripTitle = (b?.tripTitle.isNotEmpty == true)
        ? b!.tripTitle
        : (data?['tripTitle']?.toString() ??
            data?['trip']?['title']?.toString() ??
            'رحلة');

    final tripDates = (b?.tripDates.isNotEmpty == true)
        ? b!.tripDates
        : (data?['tripDates']?.toString() ??
            (data?['trip'] != null
                ? '${data!['trip']['startDate'] ?? ''} - ${data['trip']['endDate'] ?? ''}'
                : ''));

    final tripDuration = data?['tripDuration']?.toString() ?? 'حسب البرنامج';

    final tripImage = (b?.trip?.coverImage.isNotEmpty == true
        ? b!.trip!.coverImage
        : (data?['tripImage']?.toString() ??
            data?['trip']?['coverImage']?.toString() ??
            AppAssets.homeFeatured));

    final bookingNumber = data?['bookingNumber']?.toString() ??
        (b?.id != null && b!.id.isNotEmpty
            ? '#TRP-${b.id.length > 6 ? b.id.substring(0, 6).toUpperCase() : b.id}'
            : '#TRP-000000');

    final requestDate = data?['requestDate']?.toString() ??
        (b?.createdAt != null
            ? '${b!.createdAt!.day}/${b.createdAt!.month}/${b.createdAt!.year}'
            : 'اليوم');

    final passengersCount = b != null
        ? '${b.passengersCount} شخص'
        : (data?['passengersCount']?.toString() ?? '1 شخص');

    final paymentMethod = data?['paymentMethod']?.toString() ?? 'بطاقة بنكية';

    final totalAmount = b != null
        ? '${b.totalAmount.toStringAsFixed(0)} ج.م'
        : (data?['totalAmount']?.toString() ?? '0 ج.م');

    final customerNotes = data?['customerNotes']?.toString() ??
        data?['notes']?.toString() ??
        'لا توجد ملاحظات إضافية من العميل.';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.adminBookingDetailsTitle,
          style: AppTextStyles.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p20,
                vertical: AppSizes.p16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminBookingStatusBanner(status: _currentStatus),
                  AppSizes.p20.verticalSpace,
                  _buildSectionHeader(
                    title: AppStrings.adminCustomerDataSection,
                    icon: Icons.person_outline,
                  ),
                  AppSizes.p8.verticalSpace,
                  AdminBookingCustomerCard(
                    name: customerName,
                    email: customerEmail,
                    phone: customerPhone,
                  ),
                  AppSizes.p24.verticalSpace,
                  _buildSectionHeader(
                    title: AppStrings.adminTripDataSection,
                    icon: Icons.card_travel_outlined,
                  ),
                  AppSizes.p8.verticalSpace,
                  AdminBookingTripCard(
                    title: tripTitle,
                    duration: tripDuration,
                    dates: tripDates,
                    imagePath: tripImage,
                  ),
                  AppSizes.p24.verticalSpace,
                  _buildSectionHeader(
                    title: AppStrings.adminBookingDetailsSection,
                    icon: Icons.receipt_long_outlined,
                  ),
                  AppSizes.p8.verticalSpace,
                  AdminBookingFinancialDetailsCard(
                    bookingNumber: bookingNumber,
                    requestDate: requestDate,
                    passengersCount: passengersCount,
                    paymentMethod: paymentMethod,
                    totalAmount: totalAmount,
                  ),
                  AppSizes.p24.verticalSpace,
                  _buildSectionHeader(
                    title: AppStrings.adminCustomerNotesSection,
                    icon: Icons.chat_bubble_outline,
                  ),
                  AppSizes.p8.verticalSpace,
                  AdminBookingCustomerNotesCard(notes: customerNotes),
                  AppSizes.p20.verticalSpace,
                ],
              ),
            ).expanded(),
            AdminBookingBottomActionBar(
              customerPhone: customerPhone,
              onCancelBooking: () {
                setState(() {
                  _currentStatus = 'rejected';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.adminRejectedBanner),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColors.primary),
        AppSizes.p8.horizontalSpace,
        Text(
          title,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
