import 'package:flutter/foundation.dart';

/// DashboardViewModel - Handles dashboard logic without navigation
///
/// MVVM Principle: Exposes state but does NOT handle navigation
class DashboardViewModel extends ChangeNotifier {
  // State variables
  bool _isLoading = false;
  bool _isLoggedOut = false;
  String? _userRole;
  String? _userName;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoggedOut => _isLoggedOut;
  String? get userRole => _userRole;
  String? get userName => _userName;
  String? get errorMessage => _errorMessage;

  /// Load dashboard data
  Future<void> loadDashboardData(String userRole) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call to load user data
      await Future.delayed(const Duration(seconds: 1));

      _userRole = userRole;
      _userName = 'John Doe'; // In real app, get from API/database
    } catch (e) {
      _errorMessage = 'Failed to load dashboard: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate logout API call
      await Future.delayed(const Duration(seconds: 1));

      _userRole = null;
      _userName = null;
      _isLoggedOut = true;

      // NOTE: No navigation here! The UI will listen to logout action
      // and navigate back to '/login' route
    } catch (e) {
      _errorMessage = 'Failed to logout: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
