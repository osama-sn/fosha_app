import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/user/auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    String? governorate,
    dynamic imageFile,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;

  ProfileRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.profile);
      final resData = response.data as Map<String, dynamic>;
      final userJson = (resData['data'] is Map)
          ? Map<String, dynamic>.from(resData['data'] as Map)
          : resData;
      return UserModel.fromJson(userJson);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    String? governorate,
    dynamic imageFile,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {};
      if (fullName != null && fullName.isNotEmpty) dataMap['fullName'] = fullName;
      if (phone != null && phone.isNotEmpty) dataMap['phone'] = phone;
      if (governorate != null && governorate.isNotEmpty) dataMap['governorate'] = governorate;

      dynamic bodyData = dataMap;
      if (imageFile != null) {
        final formData = FormData.fromMap({
          ...dataMap,
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        });
        bodyData = formData;
      }

      Response response;
      try {
        response = await _dioClient.dio.put(
          ApiEndpoints.profile,
          data: bodyData,
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          response = await _dioClient.dio.put(
            '/auth/profile',
            data: bodyData,
          );
        } else {
          rethrow;
        }
      }

      final resData = response.data as Map<String, dynamic>;
      final userJson = (resData['data'] is Map)
          ? Map<String, dynamic>.from(resData['data'] as Map)
          : resData;
      return UserModel.fromJson(userJson);
    } catch (e) {
      rethrow;
    }
  }
}
