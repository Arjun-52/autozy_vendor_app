import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static void goToLogin() {
    if (context != null) {
      context!.go('/');
    }
  }

  static void goToOtp() {
    if (context != null) {
      context!.go('/otp');
    }
  }

  static void goToRole() {
    if (context != null) {
      context!.go('/role');
    }
  }

  static void goToDashboard() {
    if (context != null) {
      context!.go('/dashboard');
    }
  }

  static void goToInspector() {
    if (context != null) {
      context!.go('/inspector');
    }
  }

  static void pushToDashboard() {
    if (context != null) {
      context!.pushNamed('dashboard');
    }
  }

  static void pop() {
    if (context != null && Navigator.canPop(context!)) {
      context!.pop();
    }
  }

  static void goBack() {
    if (context != null) {
      if (Navigator.canPop(context!)) {
        context!.pop();
      } else {
        goToRole();
      }
    }
  }
}
