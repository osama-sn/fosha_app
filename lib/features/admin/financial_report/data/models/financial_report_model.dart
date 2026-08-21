class FinancialSummaryModel {
  final double totalGrossRevenue;
  final double totalExpenses;
  final double totalAdminCommissionPaid;
  final double netProfit;
  final int totalBookings;
  final int totalSeats;
  final double averageBookingValue;

  const FinancialSummaryModel({
    required this.totalGrossRevenue,
    required this.totalExpenses,
    required this.totalAdminCommissionPaid,
    required this.netProfit,
    required this.totalBookings,
    required this.totalSeats,
    required this.averageBookingValue,
  });

  factory FinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    final gross = (json['totalGrossRevenue'] as num?)?.toDouble() ?? 0.0;
    final exp = (json['totalExpenses'] as num?)?.toDouble() ?? 0.0;
    final comm = (json['totalAdminCommissions'] as num?)?.toDouble() ??
        (json['totalAdminCommissionPaid'] as num?)?.toDouble() ??
        0.0;

    double net = 0.0;
    if (json['netProfit'] != null) {
      net = (json['netProfit'] as num).toDouble();
    } else if (json['totalCompanyNetPayouts'] != null) {
      net = (json['totalCompanyNetPayouts'] as num).toDouble() - exp;
    } else {
      net = gross - comm - exp;
    }

    return FinancialSummaryModel(
      totalGrossRevenue: gross,
      totalExpenses: exp,
      totalAdminCommissionPaid: comm,
      netProfit: net,
      totalBookings: (json['totalBookings'] as int?) ?? 0,
      totalSeats: (json['totalSeats'] as int?) ?? 0,
      averageBookingValue:
          (json['averageBookingValue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PerTripFinancialModel {
  final String id;
  final String title;
  final double totalRevenue;
  final double totalCommission;
  final int totalBookings;
  final int totalSeats;

  const PerTripFinancialModel({
    required this.id,
    required this.title,
    required this.totalRevenue,
    required this.totalCommission,
    required this.totalBookings,
    required this.totalSeats,
  });

  factory PerTripFinancialModel.fromJson(Map<String, dynamic> json) {
    return PerTripFinancialModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      totalCommission: (json['totalCommission'] as num?)?.toDouble() ?? 0.0,
      totalBookings: (json['totalBookings'] as int?) ?? 0,
      totalSeats: (json['totalSeats'] as int?) ?? 0,
    );
  }
}

class FinancialReportModel {
  final FinancialSummaryModel financials;
  final List<dynamic> expensesByCategory;
  final List<PerTripFinancialModel> perTripPerformance;

  const FinancialReportModel({
    required this.financials,
    required this.expensesByCategory,
    required this.perTripPerformance,
  });

  factory FinancialReportModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    final finJson = Map<String, dynamic>.from(data['financials'] as Map<String, dynamic>? ?? {});

    if (data['bookings'] is Map<String, dynamic>) {
      finJson['totalBookings'] = (data['bookings']['totalBookings'] as int?) ?? 0;
    }

    final expCatList = (data['expensesByCategory'] as List<dynamic>?) ?? [];

    List<PerTripFinancialModel> tripPerfList = [];
    if (data['perTripPerformance'] is List) {
      tripPerfList = (data['perTripPerformance'] as List<dynamic>)
          .map((e) => PerTripFinancialModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data['recentBookings'] is List) {
      final bookings = data['recentBookings'] as List<dynamic>;
      tripPerfList = bookings.map((b) {
        final bMap = b as Map<String, dynamic>;
        final tripObj = bMap['trip'] as Map<String, dynamic>? ?? {};
        return PerTripFinancialModel(
          id: tripObj['_id'] as String? ?? '',
          title: tripObj['title'] as String? ?? 'رحلة',
          totalRevenue: (bMap['totalPrice'] as num?)?.toDouble() ?? 0.0,
          totalCommission: (bMap['adminCommissionAmount'] as num?)?.toDouble() ?? 0.0,
          totalBookings: 1,
          totalSeats: (bMap['numberOfSeats'] as int?) ?? 1,
        );
      }).toList();
    }

    return FinancialReportModel(
      financials: FinancialSummaryModel.fromJson(finJson),
      expensesByCategory: expCatList,
      perTripPerformance: tripPerfList,
    );
  }
}
