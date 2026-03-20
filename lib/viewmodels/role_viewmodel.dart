import 'package:flutter/foundation.dart';

/// RoleViewModel - Handles role selection logic without navigation
/// 
/// MVVM Principle: Exposes state changes but UI handles navigation
class RoleViewModel extends ChangeNotifier {
  // Available roles
  static const List<String> availableRoles = ['Detailer', 'Manager', 'Admin'];

  // State variables
  String? _selectedRole;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get roles => availableRoles;

  /// Select a role
  Future<void> selectRole(String role) async {
    if (!availableRoles.contains(role)) {
      _errorMessage = 'Invalid role selected';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call to save role selection
      await Future.delayed(const Duration(seconds: 1));
      
      _selectedRole = role;
      
      // NOTE: No navigation here! The UI will listen to selectedRole changes
      // and trigger navigation to '/dashboard' when a role is confirmed
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
