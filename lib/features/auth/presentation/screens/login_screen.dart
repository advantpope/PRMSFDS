import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_tax_system_fd/core/config/routes.dart';
import 'package:property_tax_system_fd/features/auth/presentation/providers/auth_provider.dart';
import 'package:property_tax_system_fd/features/auth/presentation/widgets/auth_form.dart';
import 'package:property_tax_system_fd/features/auth/presentation/screens/forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String selectedUserType = 'admin';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // ✅ Navigate AFTER successful login
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Logo and Title
              Column(
                children: [
                  Icon(
                    Icons.apartment,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Property Tax System',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Administration Portal',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Auth Form
              AuthForm(
                mode: AuthMode.login,
                isLoading: authState.isLoading,
                error: authState.error,
                onSubmit: (formData) async {
                  try {
                    await ref
                        .read(authProvider.notifier)
                        .login(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          // selectedUserType,
                        );
                  } catch (e) {
                    // Error is handled in the provider
                  }
                },
                onToggleMode: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
              ),

              // Demo credentials (remove in production)
              const SizedBox(height: 40),
              _buildDemoCredentials(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCredentials() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Demo Credentials',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Admin: admin / admin123', style: TextStyle(fontSize: 14)),
          const Text('Staff: staff / staff123', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
