import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//  Router
import 'package:autozy_vendor_app/core/navigation/app_router.dart';

//  Theme
import 'package:autozy_vendor_app/core/theme/app_theme.dart';

//  State Navigation
import 'package:autozy_vendor_app/widgets/state_driven_navigator.dart';

//  Dependency Injection
import 'package:autozy_vendor_app/core/di/dependency_injection.dart';

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
        ///  AUTH (Injected via DI)
        ChangeNotifierProvider(create: (_) => di.createAuthViewModel()),

        ///  ROLE (Injected via DI)
        ChangeNotifierProvider(create: (_) => di.createRoleViewModel()),

        ///  DASHBOARD (Injected via DI)
        ChangeNotifierProvider(create: (_) => di.createDashboardViewModel()),
      ],

      ///  GoRouter Integration
      child: StateDrivenNavigator(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Autozy Vendor',

          // Use custom theme with Poppins font
          theme: AppTheme.lightTheme,

          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
