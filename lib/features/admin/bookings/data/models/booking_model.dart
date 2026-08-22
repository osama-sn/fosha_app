import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/features/admin/bookings/data/constants/admin_bookings_constants.dart';

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

class BookingPassengerModel {
  final String fullName;
  final String phone;
  final int age;
  final String gender;
  final String notes;

  const BookingPassengerModel({
    required this.fullName,
    required this.phone,
    required this.age,
    required this.gender,
    this.notes = '',
  });

  factory BookingPassengerModel.fromJson(Map<String, dynamic> json) {
    return BookingPassengerModel(
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      gender: json['gender'] as String? ?? 'male',
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'phone': phone,
        'age': age,
        'gender': gender,
        'notes': notes,
      };
}

class BookingTripInfoModel {
  final String id;
  final String title;
  final String coverImage;
  final String origin;
  final String destination;
  final String startDate;
  final String endDate;

  const BookingTripInfoModel({
    required this.id,
    required this.title,
    required this.coverImage,
    this.origin = '',
    this.destination = '',
    required this.startDate,
    required this.endDate,
  });

  factory BookingTripInfoModel.fromJson(Map<String, dynamic> json) {
    return BookingTripInfoModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      coverImage: json['coverImage'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
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
  final String tripDuration;
  final String tripImage;
  final double totalAmount;
  final int passengersCount;
  final String status;
  final String? rejectionReason;
  final DateTime? createdAt;
  final String companyId;
  final String companyName;
  final String tripId;
  final String bookingNumber;
  final String paymentMethod;
  final String paymentSenderInstaPay;
  final String paymentSenderNumber;
  final String paymentReceiptImage;
  final String paymentNotes;
  final String paymentStatus;
  final String pickupPoint;
  final String pickupTime;
  final String couponCode;
  final String customerNotes;
  final List<BookingPassengerModel> passengers;

  const BookingModel({
    required this.id,
    this.user,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    this.trip,
    required this.tripTitle,
    required this.tripDates,
    this.tripDuration = '',
    this.tripImage = '',
    required this.totalAmount,
    required this.passengersCount,
    required this.status,
    this.rejectionReason,
    this.createdAt,
    this.companyId = '',
    this.companyName = '',
    this.tripId = '',
    this.bookingNumber = '',
    this.paymentMethod = '',
    this.paymentSenderInstaPay = '',
    this.paymentSenderNumber = '',
    this.paymentReceiptImage = '',
    this.paymentNotes = '',
    this.paymentStatus = '',
    this.pickupPoint = '',
    this.pickupTime = '',
    this.couponCode = '',
    this.customerNotes = '',
    this.passengers = const [],
  });

  int get numberOfSeats => passengersCount;
  double get totalPrice => totalAmount;
  String get tripCoverImage =>
      tripImage.isNotEmpty ? tripImage : (trip?.coverImage ?? '');
  String get origin => trip?.origin ?? '';
  String get destination => trip?.destination ?? '';
  String get formattedRequestDate => createdAt != null
      ? '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}'
      : AppStrings.adminDefaultToday;
  String get formattedPassengersCount =>
      '$passengersCount ${AppStrings.adminPersonUnit}';
  String get formattedTotalAmount =>
      '${totalAmount.toStringAsFixed(0)} ${AppStrings.adminCurrencyEGP}';

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

    final idStr = (json['_id'] ?? json['id'] ?? '').toString();
    final rawBookingNumber = json['bookingNumber']?.toString();
    final formattedNum =
        (rawBookingNumber != null && rawBookingNumber.isNotEmpty)
            ? rawBookingNumber
            : (idStr.isNotEmpty
                ? '#TRP-${idStr.length > 6 ? idStr.substring(0, 6).toUpperCase() : idStr}'
                : '#TRP-000000');

    final startDate = tripObj?.startDate ?? json['startDate']?.toString() ?? '';
    final endDate = tripObj?.endDate ?? json['endDate']?.toString() ?? '';
    final datesStr = json['tripDates'] as String? ??
        (startDate.isNotEmpty && endDate.isNotEmpty
            ? '$startDate - $endDate'
            : '');

    List<BookingPassengerModel> passengersList = [];
    if (json['passengers'] is List) {
      passengersList = (json['passengers'] as List)
          .map((p) =>
              BookingPassengerModel.fromJson(Map<String, dynamic>.from(p as Map)))
          .toList();
    }

    return BookingModel(
      id: idStr,
      user: userObj,
      customerName: json['customerName'] as String? ??
          (userObj?.fullName.isNotEmpty == true
              ? userObj!.fullName
              : AppStrings.adminDefaultCustomerName),
      customerEmail:
          json['customerEmail'] as String? ?? userObj?.email ?? '',
      customerPhone:
          json['customerPhone'] as String? ?? userObj?.phone ?? '',
      trip: tripObj,
      tripTitle: json['tripTitle'] as String? ??
          tripObj?.title ??
          AppStrings.adminDefaultTripTitle,
      tripDates: datesStr,
      tripDuration:
          json['tripDuration'] as String? ?? AppStrings.adminDefaultDuration,
      tripImage: json['tripImage'] as String? ?? tripObj?.coverImage ?? '',
      totalAmount: (json['totalPrice'] as num?)?.toDouble() ??
          (json['totalAmount'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      passengersCount: (json['numberOfSeats'] as num?)?.toInt() ??
          (json['passengersCount'] as num?)?.toInt() ??
          (json['seats'] as num?)?.toInt() ??
          1,
      status: json['status'] as String? ?? AdminBookingsConstants.statusPending,
      rejectionReason: json['rejectionReason'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      companyId: (json['company'] != null)
          ? (json['company'] is Map
              ? (json['company']['_id'] ?? json['company']['id'] ?? '').toString()
              : json['company'].toString())
          : (json['companyId']?.toString() ?? ''),
      companyName: (json['company'] != null && json['company'] is Map)
          ? (json['company']['name'] as String? ??
              json['company']['fullName'] as String? ??
              '')
          : (json['companyName'] as String? ?? ''),
      tripId: tripObj?.id ?? (json['tripId']?.toString() ?? ''),
      bookingNumber: formattedNum,
      paymentMethod:
          json['paymentMethod'] as String? ?? AppStrings.adminDefaultBankCard,
      paymentSenderInstaPay: json['paymentSenderInstaPay'] as String? ?? '',
      paymentSenderNumber: json['paymentSenderNumber'] as String? ?? '',
      paymentReceiptImage: json['paymentReceiptImage'] as String? ?? '',
      paymentNotes: json['paymentNotes'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      pickupPoint: json['pickupPoint'] as String? ?? '',
      pickupTime: json['pickupTime'] as String? ?? '',
      couponCode: json['couponCode'] as String? ?? '',
      customerNotes: json['customerNotes'] as String? ??
          json['notes'] as String? ??
          AppStrings.adminNoCustomerNotes,
      passengers: passengersList,
    );
  }
}
