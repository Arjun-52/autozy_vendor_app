import 'package:flutter/foundation.dart';
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

  /// SEND OTP
  Future<void> sendOtp(String phone) async {
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
      final success = await repo.sendOtp(phone: phone);
      if (success) {
        phoneNumber = phone;
        isOtpSent = true;
        if (kDebugMode) {
          print('Controller action success: OTP sent');
        }
        // Navigate to OTP screen
        NavigationService.goToOtp();
      } else {
        throw Exception("Failed to send OTP");
      }
    }, onError: "Something went wrong while sending OTP");

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
      print('Device ID used: ldplayer-5554');
      print('API request start');
    }

    await executeOperation(() async {
      final success = await repo.verifyOtp(
        phone: phoneNumber,
        otp: otp,
        deviceId: "ldplayer-5554",
      );
      if (success) {
        isOtpVerified = true;
        if (kDebugMode) {
          print('Token storage success');
          print('Authentication success');
        }
        // Navigate to role-based dashboard automatically
        final role = ApiClient().staffRole ?? "";
        NavigationService.goToDashboardByRole(role);
      } else {
        throw Exception("Invalid OTP. Try again.");
      }
    }, onError: "Something went wrong while verifying OTP");

    if (errorMessage != null) {
      if (kDebugMode) {
        print('Authentication failure: $errorMessage');
      }
    }
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
