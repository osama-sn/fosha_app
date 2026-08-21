class CompanyInfoModel {
  final String id;
  final String name;
  final String commissionType;
  final double commissionValue;
  final double monthlySubscriptionFee;
  final String subscriptionStatus;

  const CompanyInfoModel({
    required this.id,
    required this.name,
    required this.commissionType,
    required this.commissionValue,
    required this.monthlySubscriptionFee,
    required this.subscriptionStatus,
  });

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) {
    return CompanyInfoModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      commissionType: json['commissionType'] as String? ?? 'percentage',
      commissionValue: (json['commissionValue'] as num?)?.toDouble() ?? 0.0,
      monthlySubscriptionFee:
          (json['monthlySubscriptionFee'] as num?)?.toDouble() ?? 0.0,
      subscriptionStatus: json['subscriptionStatus'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'commissionType': commissionType,
      'commissionValue': commissionValue,
      'monthlySubscriptionFee': monthlySubscriptionFee,
      'subscriptionStatus': subscriptionStatus,
    };
  }
}

class TripsStatsModel {
  final int totalTrips;
  final int publishedTrips;
  final int draftTrips;

  const TripsStatsModel({
    required this.totalTrips,
    required this.publishedTrips,
    required this.draftTrips,
  });

  factory TripsStatsModel.fromJson(Map<String, dynamic> json) {
    return TripsStatsModel(
      totalTrips:
          (json['totalTrips'] as int?) ??
          (json['totalActiveTrips'] as int?) ??
          0,
      publishedTrips: json['publishedTrips'] as int? ?? 0,
      draftTrips: json['draftTrips'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTrips': totalTrips,
      'publishedTrips': publishedTrips,
      'draftTrips': draftTrips,
    };
  }
}

class BookingsStatsModel {
  final int totalBookings;
  final int pendingBookings;
  final int approvedBookings;
  final int rejectedBookings;

  const BookingsStatsModel({
    required this.totalBookings,
    required this.pendingBookings,
    required this.approvedBookings,
    required this.rejectedBookings,
  });

  factory BookingsStatsModel.fromJson(Map<String, dynamic> json) {
    return BookingsStatsModel(
      totalBookings: json['totalBookings'] as int? ?? 0,
      pendingBookings: json['pendingBookings'] as int? ?? 0,
      approvedBookings: json['approvedBookings'] as int? ?? 0,
      rejectedBookings: json['rejectedBookings'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBookings': totalBookings,
      'pendingBookings': pendingBookings,
      'approvedBookings': approvedBookings,
      'rejectedBookings': rejectedBookings,
    };
  }
}

class FinancialsStatsModel {
  final double totalGrossRevenue;
  final double totalAdminCommissionPaid;
  final double totalCompanyNetRevenue;

  const FinancialsStatsModel({
    required this.totalGrossRevenue,
    required this.totalAdminCommissionPaid,
    required this.totalCompanyNetRevenue,
  });

  factory FinancialsStatsModel.fromJson(Map<String, dynamic> json) {
    final net = (json['totalCompanyNetRevenue'] as num?)?.toDouble() ??
        (json['totalCompanyNetPayouts'] as num?)?.toDouble() ??
        (json['companyNetRevenue'] as num?)?.toDouble();

    final gross = (json['totalGrossRevenue'] as num?)?.toDouble() ??
        (json['totalRevenue'] as num?)?.toDouble() ??
        0.0;

    final commission =
        (json['totalAdminCommissions'] as num?)?.toDouble() ??
        (json['totalAdminCommissionPaid'] as num?)?.toDouble() ??
        0.0;

    return FinancialsStatsModel(
      totalGrossRevenue: gross,
      totalAdminCommissionPaid: commission,
      totalCompanyNetRevenue: net ?? (gross - commission),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGrossRevenue': totalGrossRevenue,
      'totalAdminCommissionPaid': totalAdminCommissionPaid,
      'totalCompanyNetRevenue': totalCompanyNetRevenue,
    };
  }
}

class AdminDashboardStatsModel {
  final CompanyInfoModel? company;
  final TripsStatsModel trips;
  final BookingsStatsModel bookings;
  final FinancialsStatsModel financials;

  const AdminDashboardStatsModel({
    this.company,
    required this.trips,
    required this.bookings,
    required this.financials,
  });

  // Backward compatibility getters
  int get totalTrips => trips.totalTrips;
  int get publishedTrips => trips.publishedTrips;
  int get draftTrips => trips.draftTrips;

  int get totalBookings => bookings.totalBookings;
  int get pendingBookings => bookings.pendingBookings;
  int get approvedBookings => bookings.approvedBookings;
  int get rejectedBookings => bookings.rejectedBookings;

  double get totalRevenue => financials.totalCompanyNetRevenue;
  double get totalGrossRevenue => financials.totalGrossRevenue;
  double get totalAdminCommissionPaid => financials.totalAdminCommissionPaid;
  double get totalCompanyNetRevenue => financials.totalCompanyNetRevenue;

  factory AdminDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;

    final companyJson = data['company'] as Map<String, dynamic>?;
    final tripsJson = data['trips'] as Map<String, dynamic>? ?? {};
    final bookingsJson = data['bookings'] as Map<String, dynamic>? ?? {};
    final financialsJson = data['financials'] as Map<String, dynamic>? ?? {};

    return AdminDashboardStatsModel(
      company: companyJson != null ? CompanyInfoModel.fromJson(companyJson) : null,
      trips: TripsStatsModel.fromJson(tripsJson),
      bookings: BookingsStatsModel.fromJson(bookingsJson),
      financials: FinancialsStatsModel.fromJson(financialsJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (company != null) 'company': company!.toJson(),
      'trips': trips.toJson(),
      'bookings': bookings.toJson(),
      'financials': financials.toJson(),
    };
  }
}

