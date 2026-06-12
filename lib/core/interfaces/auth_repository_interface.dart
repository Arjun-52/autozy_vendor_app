/// Abstract interface for AuthRepository
///
/// Enables loose coupling and better testability
abstract class IAuthRepository {
  /// Send OTP through the service
  Future<bool> sendOtp({required String phone});

  /// Verify OTP through the service
  Future<bool> verifyOtp({
    required String phone,
    required String otp,
    required String deviceId,
  });

  /// Refresh auth token
  Future<bool> refreshToken({required String refreshToken});
}
