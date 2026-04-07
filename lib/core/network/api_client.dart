import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// HTTP Client for API communication
/// Currently configured for future API integration
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;

  /// Initialize the HTTP client
  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.autozy.com', // TODO: Move to config
        connectTimeout: 30000,
        receiveTimeout: 30000,
        sendTimeout: 30000,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging for debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    // Add error handling interceptor
    _dio.interceptors.add(ErrorInterceptor());
  }

  /// Get Dio instance for making requests
  Dio get dio => _dio;

  /// Check if client is initialized
  bool get isInitialized => true;
}

/// Custom interceptor for handling API errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Log error for debugging
    if (kDebugMode) {
      print('API Error: ${err.message}');
      print('Response: ${err.response?.data}');
    }

    // can add global error handling here

    handler.next(err);
  }
}
