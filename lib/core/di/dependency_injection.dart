import 'package:autozy_vendor_app/data/services/auth_service.dart';
import 'package:autozy_vendor_app/data/repositories/auth_repository.dart';
import 'package:autozy_vendor_app/viewmodels/auth_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/role_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/dashboard_viewmodel.dart';
import '../interfaces/auth_service_interface.dart';
import '../interfaces/auth_repository_interface.dart';

/// Dependency Injection Container
///
/// Centralizes all dependency creation and eliminates tight coupling
class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._internal();
  factory DependencyInjection() => _instance;
  DependencyInjection._internal();

  // Service instances (singletons)
  late final IAuthService _authService;
  late final IAuthRepository _authRepository;

  // ViewModel instances
  late final AuthViewModel _authViewModel;
  late final RoleViewModel _roleViewModel;
  late final DashboardViewModel _dashboardViewModel;

  /// Initialize all dependencies
  void initialize() {
    // Initialize services (singletons)
    _authService = AuthService();
    _authRepository = AuthRepository(_authService);

    // Initialize ViewModels
    _authViewModel = AuthViewModel(_authRepository);
    _roleViewModel = RoleViewModel();
    _dashboardViewModel = DashboardViewModel();
  }

  // Getters for services
  IAuthService get authService => _authService;
  IAuthRepository get authRepository => _authRepository;

  // Getters for ViewModels
  AuthViewModel get authViewModel => _authViewModel;
  RoleViewModel get roleViewModel => _roleViewModel;
  DashboardViewModel get dashboardViewModel => _dashboardViewModel;

  // Factory methods for creating new instances when needed
  AuthViewModel createAuthViewModel() => AuthViewModel(_authRepository);
  RoleViewModel createRoleViewModel() => RoleViewModel();
  DashboardViewModel createDashboardViewModel() => DashboardViewModel();
}

/// Global instance for easy access
final di = DependencyInjection();
