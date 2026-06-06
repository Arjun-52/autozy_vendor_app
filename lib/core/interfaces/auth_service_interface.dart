/// Abstract interface for AuthService
/// 
/// Enables loose coupling and better testability
abstract class IAuthService {
  /// Send OTP to the provided phone number
  Future<bool> sendOtp(String phone);

  /// Verify the provided OTP
  Future<bool> verifyOtp({
    required String phone,
    required String otp,
    required String deviceId,
  });

  /// Refresh auth token
  Future<bool> refreshToken({required String refreshToken});
}
