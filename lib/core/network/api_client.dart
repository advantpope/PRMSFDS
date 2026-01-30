import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:property_tax_system_fd/core/config/api_endpoints.dart';
import 'package:property_tax_system_fd/core/config/app_config.dart';

class ApiClient extends DioForNative {
  factory ApiClient() => _instance;

  ApiClient._internal() {
    // Use AppConfig directly
    options.baseUrl = AppConfig.apiBaseUrl;
    options.connectTimeout = const Duration(milliseconds: 30000);
    options.receiveTimeout = const Duration(milliseconds: 30000);
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    if (kIsWeb) {
      options.headers['Access-Control-Allow-Origin'] = '*';
    }

    if (AppConfig.isDebug) {
      print('📡 API Client initialized with URL: ${AppConfig.apiBaseUrl}');
    }
  }

  static final ApiClient _instance = ApiClient._internal();
}
