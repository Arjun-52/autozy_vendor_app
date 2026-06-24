import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../services/navigation_service.dart';

/// HTTP Client for API communication
/// Handles in-memory & local-filesystem session persistence
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  String? _token = kDebugMode ? "mock_development_access_token_jwt" : null;
  String? _refreshToken = kDebugMode ? "mock_development_refresh_token_jwt" : null;
  String? _staffRole;
  String? _profilePictureUrl;

  File get _sessionFile => File('${Directory.systemTemp.path}/autozy_session.json');

  void _saveSession() {
    try {
      _sessionFile.writeAsStringSync(jsonEncode({
        'token': _token,
        'refreshToken': _refreshToken,
        'staffRole': _staffRole,
        'profilePictureUrl': _profilePictureUrl,
      }));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving session: $e');
      }
    }
  }

  void _loadSession() {
    try {
      if (_sessionFile.existsSync()) {
        final content = _sessionFile.readAsStringSync();
        final data = jsonDecode(content) as Map<String, dynamic>;
        _token = data['token'];
        _refreshToken = data['refreshToken'];
        _staffRole = data['staffRole'];
        _profilePictureUrl = data['profilePictureUrl'];
        if (kDebugMode) {
          print('Loaded session: token=$_token, role=$_staffRole, profilePictureUrl=$_profilePictureUrl');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading session: $e');
      }
    }
  }

  /// Store authorization token in-memory & locally
  void setToken(String token) {
    _token = token;
    _saveSession();
    if (kDebugMode) {
      print('Token updated in ApiClient');
    }
  }

  /// Clear stored token
  void clearToken() {
    _token = null;
    _saveSession();
    if (kDebugMode) {
      print('Token cleared from ApiClient');
    }
  }

  /// Get current token
  String? get token => _token;

  /// Store refresh token in-memory & locally
  void setRefreshToken(String token) {
    _refreshToken = token;
    _saveSession();
    if (kDebugMode) {
      print('Refresh token updated in ApiClient');
    }
  }

  /// Clear stored refresh token
  void clearRefreshToken() {
    _refreshToken = null;
    _saveSession();
    if (kDebugMode) {
      print('Refresh token cleared from ApiClient');
    }
  }

  /// Get current refresh token
  String? get refreshToken => _refreshToken;

  /// Store staff role
  void setStaffRole(String role) {
    _staffRole = role;
    _saveSession();
    if (kDebugMode) {
      print('Staff role updated in ApiClient: $role');
    }
  }

  /// Clear staff role
  void clearStaffRole() {
    _staffRole = null;
    _saveSession();
    if (kDebugMode) {
      print('Staff role cleared from ApiClient');
    }
  }

  /// Get current staff role
  String? get staffRole => _staffRole;

  /// Get current profile picture URL
  String? get profilePictureUrl => _profilePictureUrl;

  /// Store profile picture URL
  void setProfilePictureUrl(String? url) {
    _profilePictureUrl = url;
    _saveSession();
    if (kDebugMode) {
      print('Profile picture URL updated in ApiClient: $url');
    }
  }

  /// Initialize the HTTP client
  void initialize() {
    _loadSession();

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://autozybackend.gyaanplant.co.in', // TODO: Move to config
        connectTimeout: 30000,
        receiveTimeout: 30000,
        sendTimeout: 30000,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Bypass SSL certificate verification for development/testing
    if (_dio.httpClientAdapter is DefaultHttpClientAdapter) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    // Interceptor to add Authorization header dynamically
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          } else {
            if (kDebugMode) {
              print('Warning: Request made without Authorization token');
            }
          }
          return handler.next(options);
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

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // Log error for debugging
    if (kDebugMode) {
      print('API Error: ${err.message}');
      print('Response Status: ${err.response?.statusCode}');
      print('Response Headers: ${err.response?.headers}');
      print('Response Body: ${err.response?.data}');
      print('Full Error: $err');
    }

    // Handle 401 Unauthorized globally by attempting token refresh
    if (err.response?.statusCode == 401) {
      final storedRefreshToken = ApiClient().refreshToken;
      if (storedRefreshToken != null && storedRefreshToken.isNotEmpty) {
        if (kDebugMode) {
          print('Refresh token found in storage: $storedRefreshToken');
          print('Refresh token request start');
          print('Refresh API called');
        }

        try {
          // Use a new Dio instance to call /refresh directly, avoiding interceptor recursion
          final refreshResponse = await Dio(BaseOptions(
            baseUrl: ApiClient().dio.options.baseUrl,
            connectTimeout: 30000,
            receiveTimeout: 30000,
            sendTimeout: 30000,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )).post('/api/v1/auth/refresh', data: {
            'refreshToken': storedRefreshToken,
          });

          if (refreshResponse.statusCode == 200 || refreshResponse.statusCode == 201) {
            final resData = refreshResponse.data;
            if (resData != null && resData['success'] == true) {
              final newAccessToken = resData['data']['accessToken'];
              final newRefreshToken = resData['data']['refreshToken'];

              if (newAccessToken != null && newRefreshToken != null) {
                if (kDebugMode) {
                  print('Refresh API success');
                  print('New access token received: $newAccessToken');
                  print('New refresh token received: $newRefreshToken');
                  print('Token storage success');
                }

                ApiClient().setToken(newAccessToken);
                ApiClient().setRefreshToken(newRefreshToken);

                // Retry the original failed request
                if (kDebugMode) {
                  print('Original request retry');
                }

                final options = err.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';

                final retryResponse = await ApiClient().dio.request(
                  options.path,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                  data: options.data,
                  queryParameters: options.queryParameters,
                );

                return handler.resolve(retryResponse);
              }
            }
          }
        } catch (refreshErr) {
          if (kDebugMode) {
            print('Refresh failure: $refreshErr');
            print('Forced logout triggered');
          }
          ApiClient().clearToken();
          ApiClient().clearRefreshToken();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.goToLogin();
          });
          return handler.next(err);
        }
      } else {
        if (kDebugMode) {
          print('No refresh token found. Clearing token.');
        }
        ApiClient().clearToken();
      }
    }

    handler.next(err);
  }
}
