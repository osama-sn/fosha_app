import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/user/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fosha_app/features/user/auth/data/models/register_request_model.dart';
import 'package:fosha_app/features/user/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepository({required AuthRemoteDataSource authRemoteDataSource})
    : _authRemoteDataSource = authRemoteDataSource;

  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authRemoteDataSource.login(
        email: email,
        password: password,
      );
      await _cacheAuthData(response.data);
      return Right(response.data.user);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, UserModel>> register(
    RegisterRequestModel request,
  ) async {
    try {
      final response = await _authRemoteDataSource.register(request);
      await _cacheAuthData(response.data);
      return Right(response.data.user);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, UserModel>> loginWithGoogle({
    required String idToken,
  }) async {
    try {
      final response = await _authRemoteDataSource.loginWithGoogle(
        idToken: idToken,
      );
      await _cacheAuthData(response.data);
      return Right(response.data.user);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, bool>> forgotPassword({required String email}) async {
    try {
      final success = await _authRemoteDataSource.forgotPassword(email: email);
      return Right(success);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final success = await _authRemoteDataSource.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      return Right(success);
    } catch (e) {
      return Left(ServerFailure(ApiErrorHandler.handle(e)));
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    return accessToken != null;
  }

  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('cached_user');
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> _cacheAuthData(AuthUserData response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', response.accessToken);
    await prefs.setString('refresh_token', response.refreshToken);
    await prefs.setString('cached_user', jsonEncode(response.user.toJson()));
  }

  // logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('cached_user');
  }
}
