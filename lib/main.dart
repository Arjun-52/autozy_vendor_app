import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Router
import 'package:autozy_vendor_app/core/navigation/app_router.dart';

// Theme
import 'package:autozy_vendor_app/core/theme/app_theme.dart';

// Services
import 'package:autozy_vendor_app/core/services/notification_service.dart';

// Dependency Injection
import 'package:autozy_vendor_app/core/di/dependency_injection.dart';
import 'package:autozy_vendor_app/viewmodels/auth_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/role_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/dashboard_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Notifications (FCM)
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Generate & print FCM token
  await NotificationService.generateAndPrintFCMToken();

  //  Dependency Injection
  di.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// AUTH
        ChangeNotifierProvider(create: (_) => AuthViewModel(di.authRepository)),

        /// ROLE
        ChangeNotifierProvider(create: (_) => RoleViewModel()),

        /// DASHBOARD
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(di.dashboardRepository),
        ),
      ],

      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Autozy Vendor',

        /// Theme
        theme: AppTheme.lightTheme,

        /// Routing
        routerConfig: AppRouter.router,
      ),
    );
  }
}
