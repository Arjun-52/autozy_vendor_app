import 'package:autozy_vendor_app/data/services/auth_service.dart';
import 'package:autozy_vendor_app/data/repositories/auth_repository.dart';
import '../interfaces/auth_service_interface.dart';
import '../interfaces/auth_repository_interface.dart';

/// Dependency Injection Setup
///
/// Provides service instances for Provider-based dependency injection
class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._internal();
  factory DependencyInjection() => _instance;
  DependencyInjection._internal();

  // Service instances (singletons)
  late final IAuthService _authService;
  late final IAuthRepository _authRepository;

  /// Initialize all dependencies
  void initialize() {
    // Initialize services (singletons)
    _authService = AuthService();
    _authRepository = AuthRepository(_authService);
  }

  // Getters for services
  IAuthService get authService => _authService;
  IAuthRepository get authRepository => _authRepository;
}

/// Global instance for easy access
final di = DependencyInjection();
