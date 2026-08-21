class PassengerUserModel {
  final String fullName;
  final String email;
  final String phone;

  const PassengerUserModel({
    required this.fullName,
    required this.email,
    required this.phone,
  });

  factory PassengerUserModel.fromJson(Map<String, dynamic> json) {
    return PassengerUserModel(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}

class PassengerModel {
  final String bookingId;
  final PassengerUserModel user;
  final int numberOfSeats;
  final String pickupPoint;
  final String pickupTime;
  final String status;
  final String paymentStatus;
  final double totalPrice;
  final String notes;

  const PassengerModel({
    required this.bookingId,
    required this.user,
    required this.numberOfSeats,
    required this.pickupPoint,
    required this.pickupTime,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.notes,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>? ?? {};
    return PassengerModel(
      bookingId: json['bookingId'] as String? ?? json['_id'] as String? ?? '',
      user: PassengerUserModel.fromJson(userJson),
      numberOfSeats: (json['numberOfSeats'] as int?) ?? 1,
      pickupPoint: json['pickupPoint'] as String? ?? '',
      pickupTime: json['pickupTime'] as String? ?? '',
      status: json['status'] as String? ?? 'approved',
      paymentStatus: json['paymentStatus'] as String? ?? 'paid',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String? ?? '',
    );
  }
}

class PassengerTripInfoModel {
  final String id;
  final String title;
  final String startDate;
  final int capacity;
  final int availableSeats;
  final int totalSeatsBooked;

  const PassengerTripInfoModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.capacity,
    required this.availableSeats,
    required this.totalSeatsBooked,
  });

  factory PassengerTripInfoModel.fromJson(Map<String, dynamic> json) {
    return PassengerTripInfoModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      capacity: (json['capacity'] as int?) ?? 0,
      availableSeats: (json['availableSeats'] as int?) ?? 0,
      totalSeatsBooked: (json['totalSeatsBooked'] as int?) ?? 0,
    );
  }
}

class PassengerListResponseModel {
  final PassengerTripInfoModel? trip;
  final int passengersCount;
  final int totalSeatsBooked;
  final List<PassengerModel> passengers;

  const PassengerListResponseModel({
    this.trip,
    required this.passengersCount,
    required this.totalSeatsBooked,
    required this.passengers,
  });

  factory PassengerListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    final tripJson = data['trip'] as Map<String, dynamic>?;
    final passengersList = (data['passengers'] as List<dynamic>?)
            ?.map((e) => PassengerModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PassengerListResponseModel(
      trip: tripJson != null ? PassengerTripInfoModel.fromJson(tripJson) : null,
      passengersCount: (data['passengersCount'] as int?) ?? passengersList.length,
      totalSeatsBooked: (data['totalSeatsBooked'] as int?) ?? 0,
      passengers: passengersList,
    );
  }
}
