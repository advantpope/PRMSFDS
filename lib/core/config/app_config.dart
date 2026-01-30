import 'package:flutter/foundation.dart';

class AppConfig {
  // Private constants
  static const String _apiBaseUrl = 'http://localhost:8000/api';
  static const String _googleMapsApiKey = 'YOUR_API_KEY_HERE';
  static const String _sentryDsn = '';
  static const String _appVersion = '1.0.0';

  // Public getters
  static String get apiBaseUrl => _apiBaseUrl;
  static String get googleMapsApiKey => _googleMapsApiKey;
  static String get sentryDsn => _sentryDsn;
  static bool get isDebug => kDebugMode;
  static String get appVersion => _appVersion;
}
