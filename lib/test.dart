// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:property_tax_system_fd/features/auth/data/datasources/auth_api.dart';
// import 'package:property_tax_system_fd/features/auth/data/models/auth_response.dart';
// import 'package:property_tax_system_fd/features/auth/data/models/login_request.dart';
// import 'package:property_tax_system_fd/features/auth/data/models/register_request.dart';
// import 'package:property_tax_system_fd/features/auth/data/models/user_model.dart';
// import 'package:property_tax_system_fd/features/auth/data/repositories/auth_repository_impl.dart';
// import 'package:property_tax_system_fd/features/auth/domain/repositories/auth_repository.dart';
// import 'package:property_tax_system_fd/shared/services/storage_service.dart';

// // Providers
// final authApiProvider = Provider<AuthApi>((ref) {
//   return AuthApi();
// });

// final storageServiceProvider = Provider<StorageService>((ref) {
//   return StorageService();
// });

// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   return AuthRepositoryImpl(
//     authApi: ref.read(authApiProvider),
//     storageService: ref.read(storageServiceProvider),
//   );
// });

// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
//   (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
// );

// // Auth State
// class AuthState {
//   final UserModel? user;
//   final bool isLoading;
//   final String? error;

//   const AuthState({this.user, this.isLoading = false, this.error});

//   AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
//     return AuthState(
//       user: user ?? this.user,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }

//   bool get isAuthenticated => user != null;
//   bool get isAdmin => user?.isAdmin ?? false;
// }

// // Auth Notifier
// class AuthNotifier extends StateNotifier<AuthState> {
//   final AuthRepository _authRepository;

//   AuthNotifier(this._authRepository) : super(const AuthState()) {
//     checkAuthStatus();
//   }

//   Future<void> checkAuthStatus() async {
//     try {
//       state = state.copyWith(isLoading: true);

//       final isLoggedIn = await _authRepository.isLoggedIn();
//       if (isLoggedIn) {
//         final user = await _authRepository.getCurrentUser();
//         state = state.copyWith(user: user, isLoading: false);
//       } else {
//         state = state.copyWith(isLoading: false);
//       }
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to check auth status',
//       );
//     }
//   }

//   Future<void> login({
//     required String username,
//     required String password,
//   }) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       final request = LoginRequest(username: username, password: password);

//       final response = await _authRepository.login(request);
//       state = state.copyWith(user: response.user, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       rethrow;
//     }
//   }

//   Future<void> register({
//     required String username,
//     required String email,
//     required String password,
//     required String confirmPassword,
//     required String firstName,
//     required String lastName,
//   }) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       final request = RegisterRequest(
//         username: username,
//         email: email,
//         password1: password,
//         password2: confirmPassword,
//         firstName: firstName,
//         lastName: lastName,
//       );

//       final response = await _authRepository.register(request);
//       state = state.copyWith(user: response.user, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       rethrow;
//     }
//   }

//   Future<void> logout() async {
//     try {
//       state = state.copyWith(isLoading: true);
//       await _authRepository.logout();
//       state = const AuthState(isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: 'Logout failed');
//     }
//   }

//   Future<void> resetPassword(String email) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _authRepository.resetPassword(email);
//       state = state.copyWith(isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       rethrow;
//     }
//   }

//   void clearError() {
//     state = state.copyWith(error: null);
//   }
// }

// // Helper provider to check if user is authenticated
// final isAuthenticatedProvider = Provider<bool>((ref) {
//   final authState = ref.watch(authProvider);
//   return authState.isAuthenticated;
// });

// // Helper provider to get current user
// final currentUserProvider = Provider<UserModel?>((ref) {
//   final authState = ref.watch(authProvider);
//   return authState.user;
// });

// ----property_tax_system_fd\lib\features\auth\presentation\screens\forgot_password_screen.dart----

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:property_tax_system_fd/features/auth/presentation/providers/auth_provider.dart';

// class ForgotPasswordScreen extends ConsumerStatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   ConsumerState<ForgotPasswordScreen> createState() =>
//       _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   Future<void> _resetPassword() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await ref
//             .read(authProvider.notifier)
//             .resetPassword(_emailController.text.trim());
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Password reset email sent')),
//           );
//           Navigator.pop(context);
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(e.toString())));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Forgot Password')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _resetPassword,
//                 child: const Text('Reset Password'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
