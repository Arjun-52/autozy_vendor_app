class AuthService {
  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == "1234"; // mock OTP
  }
}
