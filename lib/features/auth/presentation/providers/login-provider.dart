import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_riverpod/legacy.dart';
import '../models/login_state_model.dart';
import 'login_controller.dart';

/// Login provider instance
final StateNotifierProvider<LoginController, LoginState> loginProvider =
StateNotifierProvider<LoginController, LoginState>((Ref ref) {
  return LoginController();
});