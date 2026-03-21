import '../../core/interfaces/auth_service_interface.dart';

class AuthService implements IAuthService {
  @override
  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == "1234"; // mock OTP
  }
}
