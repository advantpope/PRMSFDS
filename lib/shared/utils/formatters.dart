import 'package:intl/intl.dart';

class Formatters {
  static final _currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _dateFormatter = DateFormat('MMM dd, yyyy');
  static final _dateTimeFormatter = DateFormat('MMM dd, yyyy hh:mm a');
  static final _numberFormatter = NumberFormat('#,###');

  static String formatCurrency(double amount) {
    return _currencyFormatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  static String formatNumber(int number) {
    return _numberFormatter.format(number);
  }

  static String formatArea(double areaSqft) {
    if (areaSqft >= 43560) {
      // Convert to acres
      final acres = areaSqft / 43560;
      return '${acres.toStringAsFixed(2)} acres';
    } else if (areaSqft >= 10000) {
      return '${(areaSqft / 10000).toStringAsFixed(2)} hectares';
    } else {
      return _numberFormatter.format(areaSqft.round());
    }
  }

  static String formatPhoneNumber(String phone) {
    if (phone.length == 10) {
      return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
    }
    return phone;
  }

  static String formatPropertyType(String type) {
    return type
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(2)}%';
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
