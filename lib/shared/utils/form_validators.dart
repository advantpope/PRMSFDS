class FormValidators {
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';

    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';

    final phoneRegex = RegExp(r'^[0-9]{10}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    if (value == null || value.isEmpty) return 'This field is required';

    final num = double.tryParse(value);
    if (num == null) {
      return 'Please enter a valid number';
    }

    if (num <= 0) {
      return 'Value must be greater than 0';
    }

    return null;
  }

  static String? yearBuilt(String? value) {
    if (value == null || value.isEmpty) return 'Year is required';

    final year = int.tryParse(value);
    if (year == null) {
      return 'Please enter a valid year';
    }

    final currentYear = DateTime.now().year;
    if (year < 1800 || year > currentYear) {
      return 'Year must be between 1800 and $currentYear';
    }

    return null;
  }

  static String? minLength(String? value, int minLength) {
    if (value == null || value.length < minLength) {
      return 'Must be at least $minLength characters';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'Cannot exceed $maxLength characters';
    }
    return null;
  }

  static String? numeric(String? value) {
    if (value == null || value.isEmpty) return null;

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static String? alphanumeric(String? value) {
    if (value == null || value.isEmpty) return null;

    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');

    if (!alphanumericRegex.hasMatch(value)) {
      return 'Only letters and numbers are allowed';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) return 'Please confirm your password';

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }
}
