import '../../core/interfaces/auth_service_interface.dart';
import '../../core/interfaces/auth_repository_interface.dart';

class AuthRepository implements IAuthRepository {
  final IAuthService service;

  AuthRepository(this.service);

  @override
  Future<bool> sendOtp({required String phone}) async {
    return await service.sendOtp(phone);
  }

  @override
  Future<bool> verifyOtp({
    required String phone,
    required String otp,
    required String deviceId,
  }) async {
    return await service.verifyOtp(phone: phone, otp: otp, deviceId: deviceId);
  }

  @override
  Future<bool> refreshToken({required String refreshToken}) async {
    return await service.refreshToken(refreshToken: refreshToken);
  }
}
