import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Simple auth state
class AuthState {
  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
    this.user,
  });
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  final Map<String, dynamic>? user;

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
    Map<String, dynamic>? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
      user: user ?? this.user,
    );
  }
}

// Simple auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(isLoading: true)) {
    // Initialize auth state
    Future.delayed(const Duration(seconds: 1), () {
      state = const AuthState(isAuthenticated: false);
    });
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    // Simulate login
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      user: {
        'id': 1,
        'username': username,
        'firstName': 'Admin',
        'lastName': 'User',
        'isAdmin': true,
      },
    );
  }

  void logout() {
    state = const AuthState(isAuthenticated: false);
  }
}
