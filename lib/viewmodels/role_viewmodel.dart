import 'package:autozy_vendor_app/data/models/role_model.dart';
import '../core/services/navigation_service.dart';
import '../core/base/base_viewmodel.dart';

class RoleViewModel extends BaseViewModel {
  // Available roles
  final List<RoleModel> availableRoles = [
    RoleModel(title: 'Detailer', subtitle: 'Daily car cleaning route'),
    RoleModel(title: 'Inspector', subtitle: 'New vehicle inspections'),
    RoleModel(title: 'Supervisor', subtitle: 'Team & route management'),
    RoleModel(title: 'Specialist', subtitle: 'Premium add-on services'),
  ];

  // State variables
  String? _selectedRole;

  // Getters
  String? get selectedRole => _selectedRole;
  List<RoleModel> get roles => availableRoles;

  /// Select a role
  Future<void> selectRole(String role) async {
    if (!isValidRole(role)) {
      setError('Invalid role selected');
      return;
    }

    await executeOperation(() async {
      await Future.delayed(const Duration(seconds: 1));
      _selectedRole = role;

      // Navigate to appropriate dashboard based on role
      if (_selectedRole == "Detailer") {
        NavigationService.goToDashboard();
      } else if (_selectedRole == "Inspector") {
        NavigationService.goToInspector();
      } else if (_selectedRole == "Supervisor") {
        // TODO: Navigate to supervisor dashboard
        NavigationService.goToDashboard(); // Temporarily navigate to regular dashboard
      } else if (_selectedRole == "Specialist") {
        // TODO: Navigate to specialist dashboard
        NavigationService.goToDashboard(); // Temporarily navigate to regular dashboard
      }
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
