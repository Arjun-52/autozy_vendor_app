import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//  Router
import 'package:autozy_vendor_app/core/navigation/app_router.dart';

//  Theme
import 'package:autozy_vendor_app/core/theme/app_theme.dart';

//  ViewModels
import 'package:autozy_vendor_app/viewmodels/auth_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/role_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/dashboard_viewmodel.dart';

//  Dependencies
import 'package:autozy_vendor_app/data/services/auth_service.dart';
import 'package:autozy_vendor_app/data/repositories/auth_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ///  AUTH (Service → Repository → ViewModel)
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(AuthRepository(AuthService())),
        ),

        ///  ROLE
        ChangeNotifierProvider(create: (_) => RoleViewModel()),

        ///  DASHBOARD
        ///
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
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
