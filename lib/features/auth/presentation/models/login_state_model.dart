/// Login state status enum
enum LoginStatus { initial, loading, success, error }

/// Login state model
class LoginState {
  final LoginStatus status;
  final String? errorMessage;
  final bool isPasswordVisible;
  final bool rememberMe;
  final String email;
  final String password;

  const LoginState({
    required this.status,
    this.errorMessage,
    required this.isPasswordVisible,
    required this.rememberMe,
    required this.email,
    required this.password,
  });

  factory LoginState.initial() {
    return const LoginState(
      status: LoginStatus.initial,
      errorMessage: null,
      isPasswordVisible: false,
      rememberMe: false,
      email: '',
      password: '',
    );
  }

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool? isPasswordVisible,
    bool? rememberMe,
    String? email,
    String? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  bool get isLoading => status == LoginStatus.loading;

  bool get isSuccess => status == LoginStatus.success;

  bool get isError => status == LoginStatus.error;

  bool get isInitial => status == LoginStatus.initial;
}
