import 'package:flutter/material.dart';

enum PasswordStrength { veryWeak, weak, fair, strong, veryStrong }

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.showText = true,
  });
  final String password;
  final bool showText;

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.veryWeak;

    int score = 0;

    // Length check
    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;

    // Character variety checks
    if (password.contains(RegExp(r'[A-Z]'))) score += 1;
    if (password.contains(RegExp(r'[a-z]'))) score += 1;
    if (password.contains(RegExp(r'[0-9]'))) score += 1;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score += 1;

    if (score >= 6) return PasswordStrength.veryStrong;
    if (score >= 5) return PasswordStrength.strong;
    if (score >= 4) return PasswordStrength.fair;
    if (score >= 3) return PasswordStrength.weak;
    return PasswordStrength.veryWeak;
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return 'Very Weak';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return Colors.red;
      case PasswordStrength.weak:
        return Colors.orange;
      case PasswordStrength.fair:
        return Colors.yellow[700]!;
      case PasswordStrength.strong:
        return Colors.green;
      case PasswordStrength.veryStrong:
        return Colors.green[800]!;
    }
  }

  double _getStrengthPercentage(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return 0.2;
      case PasswordStrength.weak:
        return 0.4;
      case PasswordStrength.fair:
        return 0.6;
      case PasswordStrength.strong:
        return 0.8;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    final color = _getStrengthColor(strength);
    final percentage = _getStrengthPercentage(strength);
    final text = _getStrengthText(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength Bar
        Container(
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),

        if (showText && password.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password Strength:',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],

        // Password Requirements
        if (password.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildRequirementsChecklist(password),
        ],
      ],
    );
  }

  Widget _buildRequirementsChecklist(String password) {
    final requirements = [
      {'label': 'At least 8 characters', 'met': password.length >= 8},
      {
        'label': 'Contains uppercase letter',
        'met': password.contains(RegExp(r'[A-Z]')),
      },
      {
        'label': 'Contains lowercase letter',
        'met': password.contains(RegExp(r'[a-z]')),
      },
      {'label': 'Contains number', 'met': password.contains(RegExp(r'[0-9]'))},
      {
        'label': 'Contains special character',
        'met': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements.map((req) {
        final met = req['met'] as bool;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Icon(
                met ? Icons.check_circle : Icons.circle_outlined,
                size: 16,
                color: met ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                req['label'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: met ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
