import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//  Router
import 'package:autozy_vendor_app/core/navigation/app_router.dart';

//  Theme
import 'package:autozy_vendor_app/core/theme/app_theme.dart';

//  Dependency Injection
import 'package:autozy_vendor_app/core/di/dependency_injection.dart';
import 'package:autozy_vendor_app/viewmodels/auth_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/role_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/dashboard_viewmodel.dart';

void main() {
  // Initialize dependency injection
  di.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ///  AUTH (Provider-based DI)
        ChangeNotifierProvider(create: (_) => AuthViewModel(di.authRepository)),

        ///  ROLE (Provider-based DI)
        ChangeNotifierProvider(create: (_) => RoleViewModel()),

        ///  DASHBOARD (Provider-based DI)
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(di.dashboardRepository),
        ),
      ],

      ///  GoRouter Integration
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Autozy Vendor',

        // Use custom theme with Poppins font
        theme: AppTheme.lightTheme,

        routerConfig: AppRouter.router,
      ),
    );
  }
}
