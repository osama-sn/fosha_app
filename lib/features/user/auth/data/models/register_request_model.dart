import 'package:dio/dio.dart';

class RegisterRequestModel {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String? governorate;
  final String? profileImagePath;

  const RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    this.governorate,
    this.profileImagePath,
  });

  Future<Map<String, dynamic>> toMap() async {
    final map = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'confirmPassword': confirmPassword,
    };

    if (governorate != null && governorate!.trim().isNotEmpty) {
      map['governorate'] = governorate!.trim();
    }

    if (profileImagePath != null && profileImagePath!.isNotEmpty) {
      map['profileImage'] = await MultipartFile.fromFile(
        profileImagePath!,
        filename: profileImagePath!.split('/').last,
      );
    }

    return map;
  }

  Future<FormData> toFormData() async {
    return FormData.fromMap(await toMap());
  }
}
