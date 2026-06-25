import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import '../core/interfaces/attendance_repository_interface.dart';
import '../data/models/attendance_model.dart';
import '../core/network/api_client.dart';

class AttendanceViewModel extends ChangeNotifier {
  final IAttendanceRepository _repository;

  AttendanceViewModel(this._repository);

  bool _isLoading = false;
  AttendanceModel? _attendance;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  AttendanceModel? get attendance => _attendance;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<void> markAttendance() async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // 1. Verify User Logged In
      final token = ApiClient().token;
      if (token == null || token.isEmpty) {
        throw Exception("User is not logged in. Bearer token unavailable.");
      }

      // 2. Verify GPS permission and Location Service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled. Please enable them.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied, we cannot request permissions.");
      }

      // 3. Acquire location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // 4. Call API
      final result = await _repository.markAttendance(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      _attendance = result;
      _successMessage = "Attendance marked successfully.";
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        _errorMessage = "Connection Timeout.";
      } else if (e.response != null) {
        final code = e.response!.statusCode;
        if (code == 401) {
          _errorMessage = "Unauthorized. Please log in again.";
        } else if (code == 403) {
          _errorMessage = "Access Forbidden.";
        } else if (code == 400) {
          _errorMessage = "Validation Error.";
        } else if (code == 500) {
          _errorMessage = "Server Error.";
        } else {
          _errorMessage = "Error $code: ${e.response!.statusMessage ?? 'Unknown error'}";
        }
      } else if (e.message.contains('SocketException')) {
        _errorMessage = "No Internet Connection.";
      } else {
        _errorMessage = e.message;
      }
    } catch (e) {
      final errStr = e.toString();
      if (errStr.contains('SocketException')) {
        _errorMessage = "No Internet Connection.";
      } else if (errStr.contains('TimeoutException')) {
        _errorMessage = "Connection Timeout.";
      } else {
        _errorMessage = errStr.replaceAll("Exception: ", "");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
