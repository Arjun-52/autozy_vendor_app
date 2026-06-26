import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class SpecialistApiService {
  final Dio _dio;

  SpecialistApiService(this._dio);

  Future<Response<dynamic>> fetchAssignedJobs() async {
    final token = ApiClient().token;
    final headers = <String, dynamic>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : 'Missing token',
    };

    if (kDebugMode) {
      print('========== FETCH ASSIGNED JOBS ==========');
      print(
        'Request URL: ${_dio.options.baseUrl}${ApiEndpoints.specialistAssignedJobs}',
      );
      print('Headers: $headers');
    }

    final response = await _dio.get(
      ApiEndpoints.specialistAssignedJobs,
      options: Options(headers: headers),
    );

    if (kDebugMode) {
      print('========== RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');
    }

    return response;
  }
}
