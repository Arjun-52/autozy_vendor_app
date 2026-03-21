import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:autozy_vendor_app/data/models/role_model.dart';
import '../core/services/navigation_service.dart';

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
    if (!isValidRole(role)) {
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

      // Navigate to dashboard if Detailer is selected
      if (shouldNavigateToDashboard()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NavigationService.pushToDashboard();
        });
      }
    } catch (e) {
      _errorMessage = 'Failed to select role: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Validate role
  bool isValidRole(String role) {
    return availableRoles.any((r) => r.title == role);
  }

  /// Check if selected role should navigate to dashboard
  bool shouldNavigateToDashboard() {
    return _selectedRole == "Detailer";
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
