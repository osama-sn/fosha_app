import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/bookings/data/models/booking_model.dart';
import 'package:fosha_app/features/admin/bookings/presentation/cubit/admin_bookings_cubit.dart';
import 'package:fosha_app/features/admin/bookings/presentation/cubit/admin_bookings_state.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_bookings_filter_tabs.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_bookings_list.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_bookings_trip_filter_header.dart';
import 'package:fosha_app/features/admin/bookings/presentation/widgets/admin_rejection_reason_dialog.dart';

class AdminBookingsPage extends StatelessWidget {
  final String? initialTripFilter;

  const AdminBookingsPage({super.key, this.initialTripFilter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminBookingsCubit>()..fetchBookings(),
      child: _AdminBookingsView(initialTripFilter: initialTripFilter),
    );
  }
}

class _AdminBookingsView extends StatefulWidget {
  final String? initialTripFilter;

  const _AdminBookingsView({this.initialTripFilter});

  @override
  State<_AdminBookingsView> createState() => _AdminBookingsViewState();
}

class _AdminBookingsViewState extends State<_AdminBookingsView> {
  int _selectedFilterIndex = 0;
  late String _selectedTrip;

  @override
  void initState() {
    super.initState();
    _selectedTrip = widget.initialTripFilter ?? AppStrings.adminFilterAllTrips;
  }

  String? _getStatusParam(int index) {
    switch (index) {
      case 1:
        return 'pending';
      case 2:
        return 'approved';
      case 3:
        return 'rejected';
      case 0:
      default:
        return null;
    }
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
          AppStrings.adminBookingRequestsTitle,
          style: AppTextStyles.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<AdminBookingsCubit, AdminBookingsState>(
          listener: (context, state) {
            if (state is AdminBookingsLoaded &&
                state.actionSuccessMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionSuccessMessage!),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is AdminBookingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AdminBookingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminBookingsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyMedium),
                    AppSizes.p16.verticalSpace,
                    ElevatedButton(
                      onPressed: () =>
                          context.read<AdminBookingsCubit>().fetchBookings(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            final bookings =
                state is AdminBookingsLoaded ? state.bookings : <BookingModel>[];

            final pendingCount =
                bookings.where((b) => b.status == 'pending').length;
            final approvedCount =
                bookings.where((b) => b.status == 'approved' || b.status == 'accepted').length;
            final rejectedCount =
                bookings.where((b) => b.status == 'rejected').length;

            final filterTabs = [
              '${AppStrings.bookingsFilterAll} (${bookings.length})',
              '${AppStrings.adminFilterPending} ($pendingCount)',
              '${AppStrings.adminFilterAccepted} ($approvedCount)',
              '${AppStrings.adminFilterRejected} ($rejectedCount)',
            ];

            final tripOptions = [
              AppStrings.adminFilterAllTrips,
              ...bookings.map((b) => b.tripTitle).where((t) => t.isNotEmpty).toSet(),
            ];

            if (!tripOptions.contains(_selectedTrip)) {
              _selectedTrip = AppStrings.adminFilterAllTrips;
            }

            final filteredBookings = bookings.where((b) {
              bool matchesStatus = true;
              switch (_selectedFilterIndex) {
                case 1:
                  matchesStatus = b.status == 'pending';
                  break;
                case 2:
                  matchesStatus = b.status == 'approved' || b.status == 'accepted';
                  break;
                case 3:
                  matchesStatus = b.status == 'rejected';
                  break;
                case 0:
                default:
                  matchesStatus = true;
              }

              bool matchesTrip = _selectedTrip == AppStrings.adminFilterAllTrips ||
                  b.tripTitle == _selectedTrip;

              return matchesStatus && matchesTrip;
            }).toList();

            return Column(
              children: [
                AdminBookingsFilterTabs(
                  filterTabs: filterTabs,
                  selectedIndex: _selectedFilterIndex,
                  onTabSelected: (index) {
                    setState(() {
                      _selectedFilterIndex = index;
                    });
                    context.read<AdminBookingsCubit>().fetchBookings(
                          statusFilter: _getStatusParam(index),
                        );
                  },
                ),
                AdminBookingsTripFilterHeader(
                  selectedTrip: _selectedTrip,
                  tripOptions: tripOptions,
                  onTripChanged: (val) {
                    setState(() {
                      _selectedTrip = val;
                    });
                  },
                ),
                AdminBookingsList(
                  bookings: filteredBookings,
                  onAcceptBooking: (bookingId) {
                    context.read<AdminBookingsCubit>().updateStatus(
                          bookingId: bookingId,
                          newStatus: 'approved',
                        );
                  },
                  onRejectBooking: (bookingId) {
                    AdminRejectionReasonDialog.show(
                      context,
                      onConfirmRejection: (reason) {
                        context.read<AdminBookingsCubit>().updateStatus(
                              bookingId: bookingId,
                              newStatus: 'rejected',
                              rejectionReason: reason,
                            );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


