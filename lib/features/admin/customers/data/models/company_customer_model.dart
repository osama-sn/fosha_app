class CustomerPreviousTripModel {
  final String title;

  const CustomerPreviousTripModel({required this.title});

  factory CustomerPreviousTripModel.fromJson(Map<String, dynamic> json) {
    return CustomerPreviousTripModel(
      title: json['title'] as String? ?? '',
    );
  }
}

class CompanyCustomerModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final int totalBookings;
  final double totalSpent;
  final String lastBookingDate;
  final List<CustomerPreviousTripModel> previousTrips;

  const CompanyCustomerModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.totalBookings,
    required this.totalSpent,
    required this.lastBookingDate,
    required this.previousTrips,
  });

  factory CompanyCustomerModel.fromJson(Map<String, dynamic> json) {
    final tripsList = (json['previousTrips'] as List<dynamic>?)
            ?.map((e) =>
                CustomerPreviousTripModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return CompanyCustomerModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      totalBookings: (json['totalBookings'] as int?) ?? 0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      lastBookingDate: json['lastBookingDate'] as String? ?? '',
      previousTrips: tripsList,
    );
  }
}
