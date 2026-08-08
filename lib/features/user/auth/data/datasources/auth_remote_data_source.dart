import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/user/auth/data/models/register_request_model.dart';
import 'package:fosha_app/features/user/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register(RegisterRequestModel request);

  Future<AuthResponseModel> loginWithGoogle({required String idToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final formData = await request.toFormData();
      final response = await _dioClient.dio.post(
        ApiEndpoints.register,
        data: formData,
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> loginWithGoogle({required String idToken}) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.googleAuth,
        data: {'idToken': idToken},
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
