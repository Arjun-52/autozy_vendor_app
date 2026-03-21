/// Abstract interface for AuthService
/// 
/// Enables loose coupling and better testability
abstract class IAuthService {
  /// Send OTP to the provided phone number
  Future<bool> sendOtp(String phone);

  /// Verify the provided OTP
  Future<bool> verifyOtp(String otp);
}
