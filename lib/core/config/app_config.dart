import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {

  factory AppConfig() => _instance;

  AppConfig._internal();
  static final AppConfig _instance = AppConfig._internal();

  static String get apiBaseUrl {
    return dotenv.get('API_BASE_URL',
        fallback: 'http://localhost:8000/api');
  }

  static String get googleMapsApiKey {
    return dotenv.get('GOOGLE_MAPS_API_KEY',
        fallback: 'YOUR_API_KEY_HERE');
  }

  static String get sentryDsn {
    return dotenv.get('SENTRY_DSN',
        fallback: '');
  }

  static bool get isDebug {
    return dotenv.get('ENVIRONMENT',
        fallback: 'development') == 'development';
  }

  static String get appVersion {
    return dotenv.get('APP_VERSION',
        fallback: '1.0.0');
  }
}