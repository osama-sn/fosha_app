class AdminBookingsConstants {
  AdminBookingsConstants._();

  static const String statusAll = 'all';
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusAccepted = 'accepted';
  static const String statusRejected = 'rejected';
  static const String statusCancelled = 'cancelled';

  static const String paramStatus = 'status';
  static const String paramPage = 'page';
  static const String paramLimit = 'limit';
  static const String paramRejectionReason = 'rejectionReason';
  static const String paramCancellationReason = 'cancellationReason';

  static const String keyData = 'data';
  static const String keyBookings = 'bookings';
}
