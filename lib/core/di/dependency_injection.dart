import 'package:autozy_vendor_app/data/services/auth_service.dart';
import 'package:autozy_vendor_app/data/services/api_service.dart';
import 'package:autozy_vendor_app/data/services/new_api_service.dart';
import 'package:autozy_vendor_app/data/repositories/auth_repository.dart';
import 'package:autozy_vendor_app/data/repositories/dashboard_repository.dart';
import 'package:autozy_vendor_app/data/repositories/inspector_repository.dart';
import 'package:autozy_vendor_app/data/repositories/supervisor_repository.dart';
import '../interfaces/auth_service_interface.dart';
import '../interfaces/auth_repository_interface.dart';
import '../network/api_client.dart';

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
  late final ApiService _apiService;
  late final DashboardRepository _dashboardRepository;

  // NEW: API-ready services and repositories
  late final ApiClient _apiClient;
  late final InspectorRepository _inspectorRepository;
  late final SupervisorRepository _supervisorRepository;

  /// Initialize all dependencies
  void initialize() {
    // Initialize services (singletons)
    _apiService = ApiService();
    _authService = AuthService();
    _authRepository = AuthRepository(_authService);
    _dashboardRepository = DashboardRepository(_apiService);

    // Initialize new API-ready services
    _apiClient = ApiClient();
    _apiClient.initialize();
    _inspectorRepository = InspectorRepository();
    _supervisorRepository = SupervisorRepository();
  }

  // Getters for services
  IAuthService get authService => _authService;
  IAuthRepository get authRepository => _authRepository;
  ApiService get apiService => _apiService;
  DashboardRepository get dashboardRepository => _dashboardRepository;

  // NEW: Getters for API-ready repositories
  InspectorRepository get inspectorRepository => _inspectorRepository;
  SupervisorRepository get supervisorRepository => _supervisorRepository;
}

/// Global instance for easy access
final di = DependencyInjection();
