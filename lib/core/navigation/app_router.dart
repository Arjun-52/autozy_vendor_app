import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:autozy_vendor_app/views/auth/screens/login_screen.dart';
import 'package:autozy_vendor_app/views/auth/screens/otp_screen.dart';
import 'package:autozy_vendor_app/views/role/screens/role_screen.dart';
import 'package:autozy_vendor_app/views/dashboard/screens/detailer_dashboard.dart';

/// App router configuration using GoRouter
///
/// This router follows MVVM architecture principles:
/// - Routes are defined centrally in one place
/// - Navigation is triggered only from the UI layer
/// - ViewModels expose state but don't handle navigation
/// - UI listens to ViewModel state and triggers navigation accordingly
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  static final GoRouter router = GoRouter(
    // Initial route when the app starts
    initialLocation: '/',

    // Error handling for unknown routes
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Route not found: ${state.uri.path}')),
    ),

    // Define all routes
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // OTP verification screen
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OtpScreen(),
      ),

      // Role selection screen
      GoRoute(
        path: '/role',
        name: 'role',
        builder: (context, state) => const RoleScreen(),
      ),

      // Dashboard screen
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => DetailerDashboard(),
      ),
    ],
  );
}

extension GoRouterExtension on GoRouter {
  /// Navigate to login screen
  void goToLogin() => go('/');

  /// Navigate to OTP screen
  void goToOtp() => go('/otp');

  /// Navigate to role selection
  void goToRole() => go('/role');

  /// Navigate to dashboard
  void goToDashboard() => go('/dashboard');

  /// Push login screen onto the stack
  void pushLogin() => push('/');

  void pushOtp() => push('/otp');

  void pushRole() => push('/role');

  void pushDashboard() => push('/dashboard');
}
