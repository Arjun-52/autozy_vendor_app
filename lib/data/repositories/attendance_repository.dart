import '../../core/interfaces/attendance_repository_interface.dart';
import '../../core/network/api_client.dart';
import '../models/attendance_model.dart';
import '../services/new_api_service.dart';
import 'package:dio/dio.dart';

class AttendanceRepository implements IAttendanceRepository {
  final NewApiService _apiService;

  AttendanceRepository(this._apiService);

  @override
  Future<AttendanceModel> markAttendance({required double latitude, required double longitude}) async {
    final url = '${ApiClient().dio.options.baseUrl}/api/v1/staff/attendance';
    final headers = ApiClient().dio.options.headers;
    final body = {
      'gpsLat': latitude,
      'gpsLng': longitude,
    };

    print('========== ATTENDANCE REQUEST ==========');
    print('URL: $url');
    print('Headers: $headers');
    print('Request Body: $body');

    try {
      final response = await _apiService.markAttendance(body);
      
      print('========== ATTENDANCE RESPONSE ==========');
      print('Status Code: 200/201 (Success)');
      print('Response Body: $response');

      if (response == null) {
        throw Exception("Null response received");
      }

      final Map<String, dynamic> respMap = response as Map<String, dynamic>;
      final Map<String, dynamic> dataMap = respMap['data'] as Map<String, dynamic>;

      final parsed = AttendanceModel.fromJson(dataMap);

      print('========== PARSED DATA ==========');
      print('Attendance ID: ${parsed.id}');
      print('Status: ${parsed.status}');
      print('Check In: ${parsed.checkIn}');
      print('Check Out: ${parsed.checkOut}');
      print('Latitude: ${parsed.gpsLat}');
      print('Longitude: ${parsed.gpsLng}');

      return parsed;
    } on DioError catch (e) {
      final statusCode = e.response?.statusCode;
      final responseBody = e.response?.data;

      print('========== ATTENDANCE RESPONSE ==========');
      print('Status Code: $statusCode');
      print('Response Body: $responseBody');
      rethrow;
    } catch (e) {
      print('========== ATTENDANCE RESPONSE ==========');
      print('Status Code: Error');
      print('Response Body: $e');
      rethrow;
    }
  }
}
