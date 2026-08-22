import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/constants/admin_bookings_constants.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/admin/bookings/presentation/cubit/admin_bookings_cubit.dart';
import 'package:fosha_app/features/admin/bookings/presentation/cubit/admin_bookings_state.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_bottom_action_bar.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_customer_card.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_customer_notes_card.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_financial_details_card.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_section_header.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_status_banner.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_booking_trip_card.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_rejection_reason_dialog.dart';

class AdminBookingDetailsPage extends StatelessWidget {
  final BookingModel? booking;
  final Map<String, dynamic>? bookingData;

  const AdminBookingDetailsPage({
    super.key,
    this.booking,
    this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminBookingsCubit>(),
      child: _AdminBookingDetailsView(
        booking: booking,
        bookingData: bookingData,
      ),
    );
  }
}

class _AdminBookingDetailsView extends StatefulWidget {
  final BookingModel? booking;
  final Map<String, dynamic>? bookingData;

  const _AdminBookingDetailsView({
    this.booking,
    this.bookingData,
  });

  @override
  State<_AdminBookingDetailsView> createState() =>
      __AdminBookingDetailsViewState();
}

class __AdminBookingDetailsViewState extends State<_AdminBookingDetailsView> {
  late BookingModel _booking;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking ??
        (widget.bookingData != null
            ? BookingModel.fromJson(widget.bookingData!)
            : const BookingModel(
                id: '',
                customerName: '',
                customerEmail: '',
                customerPhone: '',
                tripTitle: '',
                tripDates: '',
                totalAmount: 0,
                passengersCount: 1,
                status: AdminBookingsConstants.statusAccepted,
              ));
    _currentStatus = _booking.status;
  }

  @override
  Widget build(BuildContext context) {
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
        child: BlocListener<AdminBookingsCubit, AdminBookingsState>(
          listener: (context, state) {
            if (state is AdminBookingsLoaded &&
                state.actionSuccessMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionSuccessMessage!),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
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
                    AdminBookingSectionHeader(
                      title: AppStrings.adminCustomerDataSection,
                      icon: Icons.person_outline,
                    ),
                    AppSizes.p8.verticalSpace,
                    AdminBookingCustomerCard(
                      name: _booking.customerName,
                      email: _booking.customerEmail,
                      phone: _booking.customerPhone,
                    ),
                    AppSizes.p24.verticalSpace,
                    AdminBookingSectionHeader(
                      title: AppStrings.adminTripDataSection,
                      icon: Icons.card_travel_outlined,
                    ),
                    AppSizes.p8.verticalSpace,
                    AdminBookingTripCard(
                      title: _booking.tripTitle,
                      duration: _booking.tripDuration,
                      dates: _booking.tripDates,
                      imagePath: _booking.tripCoverImage,
                    ),
                    AppSizes.p24.verticalSpace,
                    AdminBookingSectionHeader(
                      title: AppStrings.adminBookingDetailsSection,
                      icon: Icons.receipt_long_outlined,
                    ),
                    AppSizes.p8.verticalSpace,
                    AdminBookingFinancialDetailsCard(
                      bookingNumber: _booking.bookingNumber,
                      requestDate: _booking.formattedRequestDate,
                      passengersCount: _booking.formattedPassengersCount,
                      paymentMethod: _booking.paymentMethod,
                      paymentSenderInstaPay: _booking.paymentSenderInstaPay,
                      paymentSenderNumber: _booking.paymentSenderNumber,
                      paymentNotes: _booking.paymentNotes,
                      pickupPoint: _booking.pickupPoint,
                      pickupTime: _booking.pickupTime,
                      totalAmount: _booking.formattedTotalAmount,
                    ),
                    AppSizes.p24.verticalSpace,
                    AdminBookingSectionHeader(
                      title: AppStrings.adminCustomerNotesSection,
                      icon: Icons.chat_bubble_outline,
                    ),
                    AppSizes.p8.verticalSpace,
                    AdminBookingCustomerNotesCard(notes: _booking.customerNotes),
                    AppSizes.p20.verticalSpace,
                  ],
                ),
              ).expanded(),
              AdminBookingBottomActionBar(
                customerName: _booking.customerName,
                customerPhone: _booking.customerPhone,
                bookingId: _booking.id,
                userId: _booking.user?.id,
                onCancelBooking: () {
                  AdminRejectionReasonDialog.show(
                    context,
                    onConfirmRejection: (reason) {
                      setState(() {
                        _currentStatus = AdminBookingsConstants.statusRejected;
                      });
                      if (_booking.id.isNotEmpty) {
                        context.read<AdminBookingsCubit>().updateStatus(
                              bookingId: _booking.id,
                              newStatus: AdminBookingsConstants.statusRejected,
                              rejectionReason: reason,
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppStrings.adminRejectedBanner),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
