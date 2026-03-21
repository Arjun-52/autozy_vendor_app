/// Abstract interface for AuthRepository
///
/// Enables loose coupling and better testability
abstract class IAuthRepository {
  /// Send OTP through the service
  Future<bool> sendOtp(String phone);

  /// Verify OTP through the service
  Future<bool> verifyOtp(String otp);
}
