import 'package:autozy_vendor_app/viewmodels/inspector_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/supervisor_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/specialist_tasks_viewmodel.dart';
import 'package:autozy_vendor_app/views/specialist/screens/specialist_mode_screen.dart';
import 'package:autozy_vendor_app/views/supervisor/screens/supervisor_screen.dart';
import 'package:autozy_vendor_app/views/profile/profile_screen.dart';
import 'package:autozy_vendor_app/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:autozy_vendor_app/views/auth/screens/login_screen.dart';
import 'package:autozy_vendor_app/views/auth/screens/otp_screen.dart';

import 'package:autozy_vendor_app/views/detailer/screens/detailer_dashboard.dart';
import 'package:autozy_vendor_app/views/detailer/screens/wash_history_screen.dart';
import 'package:autozy_vendor_app/viewmodels/wash_history_viewmodel.dart';
import 'package:autozy_vendor_app/views/inspector/screens/inspector_dashboard.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',

    navigatorKey: NavigationService.navigatorKey,

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Route not found: ${state.uri.path}')),
    ),

    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      /// LOGIN
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      /// OTP
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OtpScreen(),
      ),

      /// DETAILER DASHBOARD
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => DetailerDashboard(),
      ),

      /// WASH HISTORY
      GoRoute(
        path: '/wash-history',
        name: 'wash-history',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => WashHistoryViewModel(di.washHistoryRepository),
          child: const WashHistoryScreen(),
        ),
      ),

      /// SUPERVISOR
      GoRoute(
        path: '/supervisor',
        name: 'supervisor',
        builder: (context, state) => const SupervisorScreen(),
      ),

      /// INSPECTOR
      GoRoute(
        path: '/inspector',
        name: 'inspector',
        builder: (context, state) => const InspectorDashboard(),
      ),

      /// SPECIALIST
      GoRoute(
        path: '/specialist',
        name: 'specialist',
        builder: (context, state) => const SpecialistModeScreen(),
      ),

      /// PROFILE
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}

extension GoRouterExtension on GoRouter {
  void goToLogin() => go('/');
  void pushLogin() => push('/');

  void goToOtp() => go('/otp');
  void pushOtp() => push('/otp');

  void goToDashboard() => go('/dashboard');
  void pushDashboard() => push('/dashboard');

  void goToWashHistory() => go('/wash-history');
  void pushWashHistory() => push('/wash-history');

  void goToSupervisor() => go('/supervisor');
  void pushSupervisor() => push('/supervisor');

  void goToInspector() => go('/inspector');
  void pushInspector() => push('/inspector');

  void goToSpecialist() => go('/specialist');
  void pushSpecialist() => push('/specialist');

  void goToProfile() => go('/profile');
  void pushProfile() => push('/profile');
}
