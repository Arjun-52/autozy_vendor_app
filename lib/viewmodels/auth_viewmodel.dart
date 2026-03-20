import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';

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

    if (phone.isEmpty || phone.length != 10) {
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
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      isOtpVerified = true;
    } catch (e) {
      errorMessage = 'Something went wrong';
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
