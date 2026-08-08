class BookingCustomerModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;

  const BookingCustomerModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  factory BookingCustomerModel.fromJson(Map<String, dynamic> json) {
    return BookingCustomerModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      fullName: json['fullName'] as String? ?? json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}

class BookingTripInfoModel {
  final String id;
  final String title;
  final String coverImage;
  final String startDate;
  final String endDate;

  const BookingTripInfoModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.startDate,
    required this.endDate,
  });

  factory BookingTripInfoModel.fromJson(Map<String, dynamic> json) {
    return BookingTripInfoModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      coverImage: json['coverImage'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
    );
  }
}

class BookingModel {
  final String id;
  final BookingCustomerModel? user;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final BookingTripInfoModel? trip;
  final String tripTitle;
  final String tripDates;
  final double totalAmount;
  final int passengersCount;
  final String status;
  final String? rejectionReason;
  final DateTime? createdAt;

  const BookingModel({
    required this.id,
    this.user,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    this.trip,
    required this.tripTitle,
    required this.tripDates,
    required this.totalAmount,
    required this.passengersCount,
    required this.status,
    this.rejectionReason,
    this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    BookingCustomerModel? userObj;
    if (json['user'] != null && json['user'] is Map) {
      userObj = BookingCustomerModel.fromJson(
        json['user'] as Map<String, dynamic>,
      );
    }

    BookingTripInfoModel? tripObj;
    if (json['trip'] != null && json['trip'] is Map) {
      tripObj = BookingTripInfoModel.fromJson(
        json['trip'] as Map<String, dynamic>,
      );
    }

    return BookingModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      user: userObj,
      customerName:
          json['customerName'] as String? ??
          (userObj?.fullName.isNotEmpty == true ? userObj!.fullName : 'عميل'),
      customerEmail:
          json['customerEmail'] as String? ?? userObj?.email ?? '',
      customerPhone:
          json['customerPhone'] as String? ?? userObj?.phone ?? '',
      trip: tripObj,
      tripTitle: json['tripTitle'] as String? ?? tripObj?.title ?? 'رحلة',
      tripDates: json['tripDates'] as String? ??
          (tripObj != null ? '${tripObj.startDate} - ${tripObj.endDate}' : ''),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      passengersCount: json['passengersCount'] as int? ??
          json['seats'] as int? ??
          json['ticketsCount'] as int? ??
          1,
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejectionReason'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
