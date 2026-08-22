import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/user/auth/data/models/register_request_model.dart';
import 'package:fosha_app/features/user/auth/data/repositories/auth_repository.dart';
import 'package:fosha_app/features/user/auth/presentation/cubit/auth_states.dart';
export 'package:fosha_app/features/user/auth/presentation/cubit/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());
  Future<void> checkAuthStatus() async {
    try {
      final isLoggedIn = await authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await authRepository.getCachedUser();
        if (user != null) {
          emit(AuthSuccess(user: user));
          return;
        }
      }
      emit(AuthInitial());
    } catch (_) {
      emit(AuthInitial());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await authRepository.login(email: email, password: password);
    result.fold(
      (failure) => emit(AuthFailure(errorMessage: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> register(RegisterRequestModel request) async {
    emit(AuthLoading());
    final result = await authRepository.register(request);
    result.fold(
      (failure) => emit(AuthFailure(errorMessage: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> loginWithGoogle({required String idToken}) async {
    emit(AuthLoading());
    final result = await authRepository.loginWithGoogle(idToken: idToken);
    result.fold(
      (failure) => emit(AuthFailure(errorMessage: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await authRepository.logout();
    emit(AuthInitial());
  }

  Future<void> forgotPassword({required String email}) async {
    emit(AuthLoading());
    final result = await authRepository.forgotPassword(email: email);
    result.fold(
      (failure) => emit(AuthFailure(errorMessage: failure.message)),
      (success) => emit(ForgotPasswordOtpSentState(email: email)),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    final result = await authRepository.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => emit(AuthFailure(errorMessage: failure.message)),
      (success) => emit(ResetPasswordSuccessState()),
    );
  }
}
