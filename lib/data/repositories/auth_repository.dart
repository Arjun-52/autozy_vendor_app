import '../../core/interfaces/auth_service_interface.dart';
import '../../core/interfaces/auth_repository_interface.dart';

class AuthRepository implements IAuthRepository {
  final IAuthService service;

  AuthRepository(this.service);

  @override
  Future<bool> sendOtp(String phone) async {
    return await service.sendOtp(phone);
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    return await service.verifyOtp(otp);
  }
}
