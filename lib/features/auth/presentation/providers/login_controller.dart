import 'package:flutter_riverpod/legacy.dart';
import '../models/login_state_model.dart';

/// Login provider - handles all login logic
class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(LoginState.initial());

  /// Toggle password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// Toggle remember me
  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  /// Update email
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  /// Update password
  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  /// Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Handle login
  Future<void> login() async {
    // Set loading state
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);

    try {
      // Simulate API call
      await Future<dynamic>.delayed(const Duration(seconds: 2));

      // Simulate success
      // In real app, call your authentication service here
      // final response = await authService.login(state.email, state.password);

      // For demo purposes, check for a simple condition
      state = state.copyWith(status: LoginStatus.success, errorMessage: null);

      // if (state.email == '') {
      //   state = state.copyWith(status: LoginStatus.success, errorMessage: null);
      // } else {
      //   throw Exception('Invalid credentials');
      // }
    } catch (e) {
      // Set error state
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Handle social login (Google, Apple, etc.)
  Future<void> socialLogin(String provider) async {
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);

    try {
      // Simulate social login API call
      await Future<dynamic>.delayed(const Duration(seconds: 1));

      state = state.copyWith(status: LoginStatus.success, errorMessage: null);
    } catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: 'Failed to login with $provider',
      );
    }
  }

  /// Reset state
  void reset() {
    state = LoginState.initial();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(status: LoginStatus.initial, errorMessage: null);
  }
}


