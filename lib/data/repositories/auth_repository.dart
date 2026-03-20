import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository(this.service);

  Future<bool> sendOtp(String phone) async {
    return await service.sendOtp(phone);
  }

  Future<bool> verifyOtp(String otp) async {
    return await service.verifyOtp(otp);
  }
}
