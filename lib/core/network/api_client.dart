import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:property_tax_system_fd/core/config/api_endpoints.dart';
import 'package:property_tax_system_fd/core/config/app_config.dart';
import 'package:property_tax_system_fd/core/services/token_storage.dart';
import 'package:property_tax_system_fd/features/auth/data/models/user_model.dart';
import 'package:property_tax_system_fd/shared/services/storage_service.dart';

class ApiClient extends DioForNative {
  factory ApiClient() => _instance;

  ApiClient._internal() {
    // Base configuration
    options.baseUrl = AppConfig.apiBaseUrl;
    options.connectTimeout = Duration(
      milliseconds: int.parse(dotenv.get('API_TIMEOUT', fallback: '30000')),
    );
    options.receiveTimeout = Duration(
      milliseconds: int.parse(dotenv.get('API_TIMEOUT', fallback: '30000')),
    );

    // Add interceptors
    _addInterceptors();

    // For web, we might need different configuration
    if (kIsWeb) {
      options.headers['Access-Control-Allow-Origin'] = '*';
    }
  }
  static final ApiClient _instance = ApiClient._internal();

  void _addInterceptors() {
    // Request interceptor for auth token
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await TokenStorage().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] =
                'Token $token'; // Or 'Bearer $token' for JWT
          }
          // Add Django-specific headers
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log responses in debug mode
          if (AppConfig.isDebug) {
            debugPrint(
              'Response: ${response.statusCode} ${response.requestOptions.path}',
            );
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          // Handle token expiration (401)
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request
              return handler.resolve(await _retry(error.requestOptions));
            }
          }

          // Handle other errors
          if (AppConfig.isDebug) {
            debugPrint(
              'API Error: ${error.response?.statusCode} - ${error.message}',
            );
          }

          return handler.next(error);
        },
      ),
    );

    // Logging interceptor for debugging
    if (AppConfig.isDebug) {
      interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await StorageService().getRefreshToken();
      if (refreshToken == null) return false;

      final response = await post(
        ApiEndpoints.refreshToken,
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['access'];
        await StorageService().saveAuthToken(newToken);
        return true;
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
