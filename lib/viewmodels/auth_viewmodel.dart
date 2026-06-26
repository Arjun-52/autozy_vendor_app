import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../core/base/base_viewmodel.dart';
import '../core/interfaces/auth_repository_interface.dart';
import '../core/services/navigation_service.dart';
import '../core/network/api_client.dart';

class AuthViewModel extends BaseViewModel {
  final IAuthRepository repo;

  AuthViewModel(this.repo);

  bool isOtpSent = false;
  bool isOtpVerified = false;
  String phoneNumber = "";

  String _parseDioError(dynamic e) {
    if (e is DioError) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      
      String? backendMessage;
      if (responseData is Map<String, dynamic>) {
        backendMessage = responseData['message']?.toString() ?? 
                         responseData['error']?.toString() ??
                         (responseData['data'] is Map ? responseData['data']['message']?.toString() : null);
      } else if (responseData is String) {
        try {
          final parsed = jsonDecode(responseData);
          if (parsed is Map<String, dynamic>) {
            backendMessage = parsed['message']?.toString() ?? parsed['error']?.toString();
          }
        } catch (_) {}
      }

      // If status is 404, or backend message suggests user/staff/number not found
      if (statusCode == 404 || 
          (backendMessage != null && (
            backendMessage.toLowerCase().contains("not found") || 
            backendMessage.toLowerCase().contains("does not exist") ||
            backendMessage.toLowerCase().contains("unregistered") ||
            backendMessage.toLowerCase().contains("no staff") ||
            backendMessage.toLowerCase().contains("invalid number") ||
            backendMessage.toLowerCase().contains("invalid user")
          ))) {
        return "Number not found. Please contact your administrator.";
      }
      
      // Otherwise return the backend message if available
      if (backendMessage != null && backendMessage.isNotEmpty) {
        return backendMessage;
      }
      
      // Fallback for other status codes / issues
      if (statusCode != null) {
        return "Server error ($statusCode). Please try again.";
      }
    }
    
    return e.toString();
  }

  /// SEND OTP
  Future<void> sendOtp(String phone) async {
    // Reset any previous OTP state before a new attempt
    reset();
    if (kDebugMode) {
      print('Controller action start: sendOtp');
    }
    if (!isValidPhone(phone)) {
      setError("Enter valid phone number");
      if (kDebugMode) {
        print('Controller action failure: Invalid phone number format');
      }
      return;
    }

    await executeOperation(() async {
      try {
        final success = await repo.sendOtp(phone: phone);
        if (success) {
          phoneNumber = phone;
          isOtpSent = true;
                    // Notify listeners to trigger navigation via StateDrivenNavigator
          notifyListeners();
          NavigationService.goToOtp();
          if (kDebugMode) {
            print('Controller action success: OTP sent');
          }
          // Navigate to OTP screen only after successful OTP dispatch

        } else {
          // Backend indicated failure (e.g., number not found or inactive)
          // Ensure OTP flags are cleared
          isOtpSent = false;
          setError("Number not identified. Please contact your administrator.");
        }
      } catch (e) {
        final friendlyError = _parseDioError(e);
        setError(friendlyError);
      }
    });

    if (errorMessage != null) {
      if (kDebugMode) {
        print('Controller action failure: $errorMessage');
      }
    }
  }

  /// VERIFY OTP
  Future<void> verifyOtp(String otp) async {
    final validationError = validateOtp(otp);
    if (validationError != null) {
      setError(validationError);
      return;
    }

    if (kDebugMode) {
      print('Verify OTP button tapped');
      print('Phone number received: $phoneNumber');
      print('OTP submitted: $otp');
      print('API request start');
    }

    await executeOperation(() async {
      try {
        final success = await repo.verifyOtp(
          phone: phoneNumber,
          otp: otp,
          deviceId: "autozy-vendor-app",
        );
        if (success) {
          isOtpVerified = true;
          if (kDebugMode) {
            print('Token storage success');
            print('Authentication success');
          }
          final role = ApiClient().staffRole ?? "";
          NavigationService.goToDashboardByRole(role);
        } else {
          setError("Invalid OTP. Please try again.");
          if (kDebugMode) {
            print('Authentication failure: success=false');
          }
        }
      } on DioError catch (e) {
        if (kDebugMode) {
          print('verifyOtp DioError status: ${e.response?.statusCode}');
          print('verifyOtp DioError body: ${e.response?.data}');
        }
        final friendlyError = _parseDioError(e);
        setError(friendlyError);
        if (kDebugMode) {
          print('Authentication failure: $friendlyError');
        }
      } catch (e) {
        if (kDebugMode) {
          print('verifyOtp unexpected error: $e');
        }
        setError("Something went wrong. Please try again.");
      }
    });
  }

  /// Validate phone number
  bool isValidPhone(String phone) {
    return phone.isNotEmpty && phone.length == 10;
  }

  /// Validate OTP
  String? validateOtp(String otp) {
    if (otp.isEmpty) return "Please enter OTP";
    if (otp.length < 6) return "Enter complete OTP";
    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) return "OTP must be numeric";
    return null;
  }

  /// RESET
  void reset() {
    isOtpSent = false;
    isOtpVerified = false;
    phoneNumber = "";
    resetBaseState();
  }

  /// Reset verification state only (for OTP screen)
  void resetVerificationState() {
    isOtpVerified = false;
    clearError();
  }
}
