import '../core/base/base_viewmodel.dart';
import '../core/interfaces/auth_repository_interface.dart';

class AuthViewModel extends BaseViewModel {
  final IAuthRepository repo;

  AuthViewModel(this.repo);

  bool isOtpSent = false;
  bool isOtpVerified = false;
  String phoneNumber = "";

  /// SEND OTP
  Future<void> sendOtp(String phone) async {
    if (!isValidPhone(phone)) {
      setError("Enter valid phone number");
      return;
    }

    await executeOperation(() async {
      final success = await repo.sendOtp(phone);
      if (success) {
        phoneNumber = phone;
        isOtpSent = true;
      } else {
        throw Exception("Failed to send OTP");
      }
    }, onError: "Something went wrong while sending OTP");
  }

  /// VERIFY OTP
  Future<void> verifyOtp(String otp) async {
    final validationError = validateOtp(otp);
    if (validationError != null) {
      setError(validationError);
      return;
    }

    await executeOperation(() async {
      await Future.delayed(const Duration(seconds: 1));
      isOtpVerified = true;
    }, onError: "Something went wrong while verifying OTP");
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

  /// RESET
  void reset() {
    isOtpSent = false;
    isOtpVerified = false;
    phoneNumber = "";
    resetBaseState();
  }
}
