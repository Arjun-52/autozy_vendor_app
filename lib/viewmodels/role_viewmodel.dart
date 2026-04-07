import 'package:autozy_vendor_app/data/models/role_model.dart';
import '../core/base/base_viewmodel.dart';
import '../core/interfaces/role_repository_interface.dart';

class RoleViewModel extends BaseViewModel {
  final IRoleRepository _repository;

  RoleViewModel(this._repository);

  // Available roles - loaded from repository
  List<RoleModel> _availableRoles = [];
  List<RoleModel> get availableRoles => _availableRoles;

  // State variables
  String? _selectedRole;

  // Getters
  String? get selectedRole => _selectedRole;
  List<RoleModel> get roles => availableRoles;

  /// Load roles from repository
  Future<void> loadRoles() async {
    await executeOperation(() async {
      _availableRoles = await _repository.getRoles();
    }, onError: 'Failed to load roles');
  }

  /// Select a role
  Future<void> selectRole(String role) async {
    if (!isValidRole(role)) {
      setError('Invalid role selected');
      return;
    }

    await executeOperation(() async {
      final success = await _repository.selectRole(role);
      if (success) {
        _selectedRole = role;
      } else {
        throw Exception("Failed to select role");
      }

      // Navigation is now handled by the UI using GoRouter
      // This method only updates the selected role state
    }, onError: 'Failed to select role');
  }

  /// Validate role
  bool isValidRole(String role) {
    return availableRoles.any((r) => r.title == role);
  }

  bool shouldNavigateToDashboard() {
    return _selectedRole == "Detailer";
  }

  /// Reset role selection
  void resetRole() {
    _selectedRole = null;
    resetBaseState();
  }
}
