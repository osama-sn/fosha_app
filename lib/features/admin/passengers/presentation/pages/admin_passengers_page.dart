import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/passengers/presentation/cubit/admin_passengers_cubit.dart';
import 'package:fosha_app/features/admin/passengers/presentation/widgets/admin_announcement_dialog.dart';
import 'package:fosha_app/features/admin/passengers/presentation/widgets/admin_passenger_card.dart';
import 'package:fosha_app/features/admin/passengers/presentation/widgets/admin_passengers_empty_view.dart';
import 'package:fosha_app/features/admin/passengers/presentation/widgets/admin_passengers_summary_bar.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/admin/trips/data/repositories/admin_trips_repository.dart';

class AdminPassengersPage extends StatefulWidget {
  final String? initialTripId;

  const AdminPassengersPage({super.key, this.initialTripId});

  @override
  State<AdminPassengersPage> createState() => _AdminPassengersPageState();
}

class _AdminPassengersPageState extends State<AdminPassengersPage> {
  List<TripModel> _trips = [];
  TripModel? _selectedTrip;
  bool _loadingTrips = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    try {
      final repo = getIt<AdminTripsRepository>();
      final result = await repo.getTrips(page: 1, limit: 50);
      result.fold(
        (_) {
          if (mounted) setState(() => _loadingTrips = false);
        },
        (paginatedTrips) {
          if (mounted) {
            setState(() {
              _trips = paginatedTrips.trips;
              _loadingTrips = false;
              if (_trips.isNotEmpty) {
                if (widget.initialTripId != null) {
                  _selectedTrip = _trips.firstWhere(
                    (t) => t.id == widget.initialTripId,
                    orElse: () => _trips.first,
                  );
                } else {
                  _selectedTrip = _trips.first;
                }
              }
            });

            if (_selectedTrip != null && mounted) {
              context
                  .read<AdminPassengersCubit>()
                  .fetchPassengers(_selectedTrip!.id);
            }
          }
        },
      );
    } catch (_) {
      if (mounted) {
        setState(() => _loadingTrips = false);
      }
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
          AppStrings.adminPassengersTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: _loadingTrips
          ? const Center(child: AppLoading())
          : _trips.isEmpty
              ? Center(
                  child: Text(
                    AppStrings.adminNoTripsYet,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                )
              : Column(
                  children: [
                    // Trip Selection Dropdown & Search Bar
                    Container(
                      padding: EdgeInsets.all(16.r),
                      color: AppColors.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.adminSelectTripLabel,
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<TripModel>(
                                isExpanded: true,
                                value: _selectedTrip,
                                items: _trips.map((trip) {
                                  return DropdownMenuItem(
                                    value: trip,
                                    child: Text(
                                      trip.title,
                                      style: AppTextStyles.bodyMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newTrip) {
                                  if (newTrip != null) {
                                    setState(() => _selectedTrip = newTrip);
                                    context
                                        .read<AdminPassengersCubit>()
                                        .fetchPassengers(newTrip.id);
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (val) =>
                                      setState(() => _searchQuery = val),
                                  decoration: InputDecoration(
                                    hintText:
                                        AppStrings.adminSearchPassengerHint,
                                    prefixIcon: const Icon(Icons.search),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 12.w,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: const BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              InkWell(
                                onTap: _selectedTrip == null
                                    ? null
                                    : () {
                                        AdminAnnouncementDialog.show(
                                          context,
                                          tripId: _selectedTrip!.id,
                                          onSend: (title, message) {
                                            context
                                                .read<AdminPassengersCubit>()
                                                .sendAnnouncement(
                                                  tripId: _selectedTrip!.id,
                                                  title: title,
                                                  message: message,
                                                );
                                          },
                                        );
                                      },
                                borderRadius: BorderRadius.circular(10.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedTrip == null
                                        ? Colors.grey.shade400
                                        : AppColors.primary,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.campaign,
                                          color: Colors.white, size: 18),
                                      SizedBox(width: 4.w),
                                      Text(
                                        AppStrings.adminSendNotification,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Passengers List Area
                    Expanded(
                      child: BlocConsumer<AdminPassengersCubit,
                          AdminPassengersState>(
                        listener: (context, state) {
                          if (state is AdminAnnouncementSentSuccess) {
                            AppSnackbar.showSuccess(
                              context: context,
                              message: state.message,
                            );
                            if (_selectedTrip != null) {
                              context
                                  .read<AdminPassengersCubit>()
                                  .fetchPassengers(_selectedTrip!.id);
                            }
                          } else if (state is AdminAnnouncementError) {
                            AppSnackbar.showError(
                              context: context,
                              message: state.message,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is AdminPassengersLoading) {
                            return const Center(child: AppLoading());
                          }
                          if (state is AdminPassengersError) {
                            return Center(
                              child: Text(
                                state.message,
                                style: const TextStyle(color: AppColors.error),
                              ),
                            );
                          }
                          if (state is AdminPassengersLoaded) {
                            final data = state.data;
                            final filteredPassengers =
                                data.passengers.where((p) {
                              if (_searchQuery.isEmpty) return true;
                              final query = _searchQuery.toLowerCase();
                              return p.user.fullName
                                      .toLowerCase()
                                      .contains(query) ||
                                  p.user.phone.contains(query);
                            }).toList();

                            return ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              children: [
                                AdminPassengersSummaryBar(
                                  passengersCount: data.passengersCount,
                                  totalSeatsBooked: data.totalSeatsBooked,
                                  capacity: data.trip?.capacity ??
                                      _selectedTrip?.capacity ??
                                      0,
                                ),
                                SizedBox(height: 12.h),
                                if (filteredPassengers.isEmpty)
                                  const AdminPassengersEmptyView()
                                else
                                  ...filteredPassengers.map(
                                    (passenger) => AdminPassengerCard(
                                      passenger: passenger,
                                    ),
                                  ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
