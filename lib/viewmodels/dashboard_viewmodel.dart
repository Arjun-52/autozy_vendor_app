import 'package:flutter/material.dart';
import '../core/services/navigation_service.dart';
import '../core/base/base_viewmodel.dart';

class DashboardViewModel extends BaseViewModel {
  // State variables
  bool _isLoggedOut = false;
  String? _userRole;
  String? _userName;

  // Getters
  bool get isLoggedOut => _isLoggedOut;
  String? get userRole => _userRole;
  String? get userName => _userName;

  Future<void> loadDashboardData(String userRole) async {
    await executeOperation(() async {
      await Future.delayed(const Duration(seconds: 1));
      _userRole = userRole;
      _userName = 'John Doe';
    }, onError: 'Failed to load dashboard');
  }

  /// Handle back navigation
  void handleBackNavigation() {
    if (NavigationService.context != null &&
        Navigator.canPop(NavigationService.context!)) {
      NavigationService.pop();
    } else {
      NavigationService.goToRole();
    }
  }

  /// Logout user
  Future<void> logout() async {
    await executeOperation(() async {
      await Future.delayed(const Duration(seconds: 1));
      _userRole = null;
      _userName = null;
      _isLoggedOut = true;
      // Navigate to role screen
      NavigationService.goToRole();
    }, onError: 'Failed to logout');
  }

  /// Reset logout state
  void resetRole() {
    _isLoggedOut = false;
    notifyListeners();
  }
}
