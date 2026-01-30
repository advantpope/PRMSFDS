import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_tax_system_fd/features/auth/presentation/widgets/password_strength_indicator.dart';
import 'package:property_tax_system_fd/shared/utils/form_validators.dart';

enum AuthMode { login, register }

class AuthForm extends StatefulWidget {
  final AuthMode mode;
  final VoidCallback? onToggleMode;
  final ValueChanged<Map<String, dynamic>> onSubmit;
  final bool isLoading;
  final String? error;
  final Map<String, String>? initialValues;

  const AuthForm({
    super.key,
    required this.mode,
    this.onToggleMode,
    required this.onSubmit,
    this.isLoading = false,
    this.error,
    this.initialValues,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.initialValues != null) {
      _usernameController.text = widget.initialValues!['username'] ?? '';
      _emailController.text = widget.initialValues!['email'] ?? '';
      _firstNameController.text = widget.initialValues!['firstName'] ?? '';
      _lastNameController.text = widget.initialValues!['lastName'] ?? '';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'username': _usernameController.text.trim(),
        'password': _passwordController.text,
      };

      if (widget.mode == AuthMode.register) {
        formData.addAll({
          'email': _emailController.text.trim(),
          'confirmPassword': _confirmPasswordController.text,
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
        });
      }

      if (widget.mode == AuthMode.login) {
        formData['rememberMe'] = _rememberMe.toString();
      }

      widget.onSubmit(formData);
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Username Field
          _buildTextField(
            controller: _usernameController,
            label: 'Username',
            icon: Icons.person_outline,
            validator: (value) => FormValidators.required(value),
          ),
          const SizedBox(height: 16),

          // Email Field (Register only)
          if (widget.mode == AuthMode.register) ...[
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => FormValidators.email(value),
            ),
            const SizedBox(height: 16),
          ],

          // First Name & Last Name Fields (Register only)
          if (widget.mode == AuthMode.register)
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    icon: Icons.person,
                    validator: (value) => FormValidators.required(value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    validator: (value) => FormValidators.required(value),
                  ),
                ),
              ],
            ),
          if (widget.mode == AuthMode.register) const SizedBox(height: 16),

          // Password Field
          _buildPasswordField(
            controller: _passwordController,
            label: widget.mode == AuthMode.login
                ? 'Password'
                : 'Create Password',
            obscureText: _obscurePassword,
            onToggleVisibility: _togglePasswordVisibility,
            validator: widget.mode == AuthMode.login
                ? (value) => FormValidators.required(value)
                : (value) => FormValidators.password(value),
          ),
          const SizedBox(height: 16),

          // Confirm Password Field (Register only)
          if (widget.mode == AuthMode.register) ...[
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              obscureText: _obscureConfirmPassword,
              onToggleVisibility: _toggleConfirmPasswordVisibility,
              validator: (value) => FormValidators.confirmPassword(
                value,
                _passwordController.text,
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (widget.mode == AuthMode.register &&
              _passwordController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: PasswordStrengthIndicator(
                password: _passwordController.text,
              ),
            ),

          // Remember Me & Forgot Password (Login only)
          if (widget.mode == AuthMode.login) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() => _rememberMe = value ?? false);
                      },
                    ),
                    const Text('Remember me'),
                  ],
                ),
                TextButton(
                  onPressed: widget.onToggleMode,
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Error Message
          if (widget.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildErrorWidget(widget.error!),
            ),

          // Submit Button
          ElevatedButton(
            onPressed: widget.isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    widget.mode == AuthMode.login
                        ? 'SIGN IN'
                        : 'CREATE ACCOUNT',
                  ),
          ),
          const SizedBox(height: 24),

          // Mode Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.mode == AuthMode.login
                    ? "Don't have an account?"
                    : 'Already have an account?',
              ),
              TextButton(
                onPressed: widget.onToggleMode,
                child: Text(
                  widget.mode == AuthMode.login ? 'Sign Up' : 'Sign In',
                ),
              ),
            ],
          ),

          // Terms & Conditions (Register only)
          if (widget.mode == AuthMode.register) ...[
            const SizedBox(height: 16),
            _buildTermsAndConditions(),
          ],

          // Divider with Social Login
          if (widget.mode == AuthMode.login) ...[
            const SizedBox(height: 32),
            _buildDividerWithText('Or continue with'),
            const SizedBox(height: 16),
            _buildSocialLoginButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggleVisibility,
        ),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(error, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(fontSize: 12, color: Colors.grey),
        children: [
          TextSpan(text: 'By creating an account, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text, style: TextStyle(color: Colors.grey[600])),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          color: Colors.red,
          onPressed: () {
            // Google login
          },
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          icon: Icons.facebook,
          color: Colors.blue,
          onPressed: () {
            // Facebook login
          },
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          icon: Icons.email,
          color: Colors.green,
          onPressed: () {
            // Email login
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
