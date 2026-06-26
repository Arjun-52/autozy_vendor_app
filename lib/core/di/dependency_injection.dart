import 'package:autozy_vendor_app/data/services/auth_service.dart';
import 'package:autozy_vendor_app/data/services/api_service.dart';
import 'package:autozy_vendor_app/data/services/new_api_service.dart';
import 'package:autozy_vendor_app/data/repositories/auth_repository.dart';
import 'package:autozy_vendor_app/data/repositories/dashboard_repository.dart';
import 'package:autozy_vendor_app/data/repositories/inspector_repository.dart';
import 'package:autozy_vendor_app/data/repositories/supervisor_repository.dart';
import 'package:autozy_vendor_app/data/repositories/role_repository.dart';
import 'package:autozy_vendor_app/data/repositories/job_details_repository.dart';
import 'package:autozy_vendor_app/data/repositories/specialist_tasks_repository.dart';
import '../interfaces/auth_service_interface.dart';
import '../interfaces/auth_repository_interface.dart';
import '../interfaces/role_repository_interface.dart';
import '../interfaces/job_details_repository_interface.dart';
import '../interfaces/specialist_tasks_repository_interface.dart';
import '../interfaces/dashboard_repository_interface.dart';
import 'package:autozy_vendor_app/data/repositories/wash_history_repository.dart';
import '../interfaces/wash_history_repository_interface.dart';
import '../interfaces/attendance_repository_interface.dart';
import 'package:autozy_vendor_app/data/repositories/attendance_repository.dart';
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
  late final IDashboardRepository _dashboardRepository;

  // NEW: API-ready services and repositories
  late final ApiClient _apiClient;
  late final InspectorRepository _inspectorRepository;
  late final SupervisorRepository _supervisorRepository;
  late final IAttendanceRepository _attendanceRepository;

  // NEW: Refactored repositories
  late final IRoleRepository _roleRepository;
  late final IJobDetailsRepository _jobDetailsRepository;
  late final ISpecialistTasksRepository _specialistTasksRepository;
  late final IWashHistoryRepository _washHistoryRepository;

  /// Initialize all dependencies
  void initialize() {
    // Initialize new API-ready services
    _apiClient = ApiClient();
    _apiClient.initialize();
    final newApiService = NewApiService();

    // Initialize services (singletons)
    _apiService = ApiService();
    _authService = AuthService();
    _authRepository = AuthRepository(_authService);
    _dashboardRepository = DashboardRepository(newApiService);

    _inspectorRepository = InspectorRepository(newApiService);
    _supervisorRepository = SupervisorRepository(newApiService);
    _washHistoryRepository = WashHistoryRepository(newApiService);
    _attendanceRepository = AttendanceRepository(newApiService);

    // Initialize refactored repositories
    _roleRepository = RoleRepository();
    _jobDetailsRepository = JobDetailsRepository(newApiService);
    _specialistTasksRepository = SpecialistTasksRepository(newApiService);
  }

  // Getters for services
  IAuthService get authService => _authService;
  IAuthRepository get authRepository => _authRepository;
  ApiService get apiService => _apiService;
  IDashboardRepository get dashboardRepository => _dashboardRepository;

  // NEW: Getters for API-ready repositories
  InspectorRepository get inspectorRepository => _inspectorRepository;
  SupervisorRepository get supervisorRepository => _supervisorRepository;
  IAttendanceRepository get attendanceRepository => _attendanceRepository;

  // NEW: Getters for refactored repositories
  IRoleRepository get roleRepository => _roleRepository;
  IJobDetailsRepository get jobDetailsRepository => _jobDetailsRepository;
  ISpecialistTasksRepository get specialistTasksRepository =>
      _specialistTasksRepository;
  IWashHistoryRepository get washHistoryRepository => _washHistoryRepository;
}

/// Global instance for easy access
final di = DependencyInjection();
