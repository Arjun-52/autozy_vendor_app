import 'package:autozy_vendor_app/viewmodels/inspector_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:autozy_vendor_app/views/auth/screens/login_screen.dart';
import 'package:autozy_vendor_app/views/auth/screens/otp_screen.dart';
import 'package:autozy_vendor_app/views/role/screens/role_screen.dart';
import 'package:autozy_vendor_app/views/dashboard/screens/detailer_dashboard.dart';
import 'package:autozy_vendor_app/views/inspector/screens/inspector_dashboard.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';

class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',

    navigatorKey: NavigationService.navigatorKey,

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Route not found: ${state.uri.path}')),
    ),

    routes: [
      // Login screen
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // OTP
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OtpScreen(),
      ),

      // Role
      GoRoute(
        path: '/role',
        name: 'role',
        builder: (context, state) => const RoleScreen(),
      ),

      // Dashboard
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => DetailerDashboard(),
      ),

      // Inspector Dashboard
      GoRoute(
        path: '/inspector',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => InspectorViewModel(),
          child: const InspectorDashboard(),
        ),
      ),
    ],
  );
}

extension GoRouterExtension on GoRouter {
  /// Navigate to login s
  void goToLogin() => go('/');

  /// Navigate to OTP screen
  void goToOtp() => go('/otp');

  /// Navigate to role
  void goToRole() => go('/role');

  /// Navigate to dashboard
  void goToDashboard() => go('/dashboard');

  /// Navigate to inspector dashboard
  void goToInspector() => go('/inspector');

  void pushLogin() => push('/');

  void pushOtp() => push('/otp');

  void pushRole() => push('/role');

  void pushDashboard() => push('/dashboard');

  void pushInspector() => push('/inspector');
}
