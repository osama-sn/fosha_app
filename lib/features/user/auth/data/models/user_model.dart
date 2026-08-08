import 'package:equatable/equatable.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String profileImage;
  final String authProvider;
  final String role;
  final String? company;
  final String? governorate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;
  final List<String> fcmTokens;
  final bool isProtected;
  final String accessToken;
  final String refreshToken;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.authProvider,
    required this.role,
    this.company,
    this.governorate,
    this.createdAt,
    this.updatedAt,
    required this.v,
    required this.fcmTokens,
    required this.isProtected,
    required this.accessToken,
    required this.refreshToken,
  });

  bool get isAdmin =>
      role == "admin" || role == "company_admin" || role == "super_admin";
  bool get isCompanyAdmin => role == "company_admin";
  bool get isSuperAdmin => role == "super_admin";

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? companyId;
    if (json['company'] != null) {
      if (json['company'] is Map) {
        companyId = (json['company']['_id'] ?? json['company']['id'])
            ?.toString();
      } else {
        companyId = json['company'].toString();
      }
    }

    return UserModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      governorate: json['governorate'] as String?,
      company: companyId,
      authProvider: json['authProvider'] ?? 'local',
      role: json['role'] ?? 'user',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      v: json['__v'] ?? 0,
      fcmTokens:
          (json['fcmTokens'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isProtected: json['isProtected'] ?? false,
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'governorate': governorate,
      'company': company,
      'authProvider': authProvider,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'fcmTokens': fcmTokens,
      'isProtected': isProtected,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

class AuthResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final AuthUserData data;

  AuthResponseModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      statusCode: json['statusCode'] ?? 200,
      success: json['success'] ?? true,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: AuthUserData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AuthUserData {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthUserData({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthUserData.fromJson(Map<String, dynamic> json) {
    final userJson = Map<String, dynamic>.from(json['user'] as Map);
    final accessToken = json['accessToken'] as String? ?? '';
    final refreshToken = json['refreshToken'] as String? ?? '';
    userJson['accessToken'] = accessToken;
    userJson['refreshToken'] = refreshToken;

    return AuthUserData(
      user: UserModel.fromJson(userJson),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

class RefreshTokenResponse extends Equatable {
  final String accessToken;
  final String refreshToken;

  const RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return RefreshTokenResponse(
      accessToken:
          data['accessToken'] as String? ??
          data['access_token'] as String? ??
          '',
      refreshToken:
          data['refreshToken'] as String? ??
          data['refresh_token'] as String? ??
          '',
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
