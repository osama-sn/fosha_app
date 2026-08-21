import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/passengers/data/models/passenger_model.dart';
import 'package:fosha_app/features/admin/passengers/presentation/cubit/admin_passengers_cubit.dart';
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
          'قائمة المسافرين والمانفيست',
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
                    'لا توجد رحلات مضافة بعد',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                )
              : Column(
                  children: [
                    // Trip Selection Dropdown & Summary
                    Container(
                      padding: EdgeInsets.all(16.r),
                      color: AppColors.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اختر الرحلة:',
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
                          // Search field & Announcement button
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (val) =>
                                      setState(() => _searchQuery = val),
                                  decoration: InputDecoration(
                                    hintText: 'بحث باسم المسافر أو الهاتف...',
                                    prefixIcon: const Icon(Icons.search),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 12.w),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: const BorderSide(
                                          color: AppColors.border),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              InkWell(
                                onTap: _selectedTrip == null
                                    ? null
                                    : () => _showAnnouncementDialog(
                                        context, _selectedTrip!.id),
                                borderRadius: BorderRadius.circular(10.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 12.h),
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
                                        'إرسال إشعار',
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

                    // Passenger Content
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
                                  horizontal: 16.w, vertical: 8.h),
                              children: [
                                // Stats Summary Bar
                                Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStatItem('عدد المسافرين',
                                          '${data.passengersCount} فرد'),
                                      _buildStatItem('المقاعد الحالية',
                                          '${data.totalSeatsBooked} مقعد'),
                                      _buildStatItem(
                                        'سعة الرحلة',
                                        '${data.trip?.capacity ?? _selectedTrip?.capacity ?? 0} مقعد',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h),

                                if (filteredPassengers.isEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 40.h),
                                    child: Center(
                                      child: Text(
                                        'لا يوجد مسافرون مطابقون للبحث',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                            color: AppColors.textSecondary),
                                      ),
                                    ),
                                  )
                                else
                                  ...filteredPassengers.map((passenger) =>
                                      _buildPassengerCard(passenger)),
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

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.labelSmall
              .copyWith(color: AppColors.textSecondary, fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _buildPassengerCard(PassengerModel passenger) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
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
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(
                    passenger.user.fullName.isNotEmpty
                        ? passenger.user.fullName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passenger.user.fullName,
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        passenger.user.phone,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${passenger.numberOfSeats} مقاعد',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 20.h),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: AppColors.primary),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    'نقطة التجمع: ${passenger.pickupPoint.isNotEmpty ? passenger.pickupPoint : "غير محددة"}',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                if (passenger.pickupTime.isNotEmpty) ...[
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    passenger.pickupTime,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
            if (passenger.notes.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Row(
                children: [
                  const Icon(Icons.note_alt_outlined,
                      size: 16, color: Colors.orange),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      'ملاحظات: ${passenger.notes}',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: Colors.orange.shade800),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAnnouncementDialog(BuildContext context, String tripId) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            const Icon(Icons.campaign, color: AppColors.primary),
            SizedBox(width: 8.w),
            const Text('إرسال تحديث/إشعار عاجل'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان الإشعار (مثلاً: تغيير موعد التحرك)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'نص الرسالة أو التحديث للمسافرين...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          AppButton(
            text: 'إرسال الآن',
            onPressed: () {
              if (titleController.text.trim().isEmpty ||
                  messageController.text.trim().isEmpty) {
                AppSnackbar.showError(
                  context: context,
                  message: 'يرجى إدخال العنوان ونص الرسالة',
                );
                return;
              }
              Navigator.pop(dialogContext);
              context.read<AdminPassengersCubit>().sendAnnouncement(
                    tripId: tripId,
                    title: titleController.text.trim(),
                    message: messageController.text.trim(),
                  );
            },
          ),
        ],
      ),
    );
  }
}
