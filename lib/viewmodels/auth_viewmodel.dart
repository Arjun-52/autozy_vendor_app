import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../core/services/navigation_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repo;

  AuthViewModel(this.repo);

  bool isLoading = false;
  bool isOtpSent = false;
  bool isOtpVerified = false;

  String? errorMessage;
  String phoneNumber = "";

  /// SEND OTP
  Future<void> sendOtp(String phone) async {
    errorMessage = null;
    isOtpSent = false;

    if (!isValidPhone(phone)) {
      errorMessage = "Enter valid phone number";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      final success = await repo.sendOtp(phone);

      if (success) {
        phoneNumber = phone;
        isOtpSent = true;
        // Navigate to OTP screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          reset();
          NavigationService.goToOtp();
        });
      } else {
        errorMessage = "Failed to send OTP";
      }
    } catch (e) {
      errorMessage = "Something went wrong";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// VERIFY OTP
  Future<void> verifyOtp(String otp) async {
    errorMessage = null;

    final validationError = validateOtp(otp);
    if (validationError != null) {
      errorMessage = validationError;
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      isOtpVerified = true;
      // Navigate to role screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reset();
        NavigationService.goToRole();
      });
    } catch (e) {
      errorMessage = 'Something went wrong';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Validate phone number
  bool isValidPhone(String phone) {
    return phone.isNotEmpty && phone.length == 10;
  }

  /// Validate OTP
  String? validateOtp(String otp) {
    if (otp.isEmpty) return "Please enter OTP";
    if (otp.length < 4) return "Enter complete OTP";
    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) return "OTP must be numeric";
    return null;
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  /// RESET
  void reset() {
    isLoading = false;
    isOtpSent = false;
    isOtpVerified = false;
    errorMessage = null;
    notifyListeners();
  }
}
