import 'package:autozy_vendor_app/data/models/role_model.dart';
import 'package:flutter/foundation.dart';

class RoleViewModel extends ChangeNotifier {
  // Available roles
  final List<RoleModel> availableRoles = [
    RoleModel(title: 'Detailer', subtitle: 'Daily car cleaning route'),
    RoleModel(title: 'Inspector', subtitle: 'New vehicle inspections'),
    RoleModel(title: 'Supervisor', subtitle: 'Team & route management'),
    RoleModel(title: 'Specialist', subtitle: 'Premium add-on services'),
  ];

  // State variables
  String? _selectedRole;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<RoleModel> get roles => availableRoles;

  /// Select a role
  Future<void> selectRole(String role) async {
    if (!availableRoles.any((r) => r.title == role)) {
      _errorMessage = 'Invalid role selected';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _selectedRole = role;
    } catch (e) {
      _errorMessage = 'Failed to select role: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset role selection
  void resetRole() {
    _selectedRole = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
