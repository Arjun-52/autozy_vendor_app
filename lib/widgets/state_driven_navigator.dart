import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/navigation_service.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class StateDrivenNavigator extends StatefulWidget {
  final Widget child;

  const StateDrivenNavigator({super.key, required this.child});

  @override
  State<StateDrivenNavigator> createState() => _StateDrivenNavigatorState();
}

class _StateDrivenNavigatorState extends State<StateDrivenNavigator> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        // Navigate to OTP when OTP is sent
        if (!_isNavigating &&
            authViewModel.isOtpSent &&
            !authViewModel.isLoading) {
          _isNavigating = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.goToOtp();
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                authViewModel.reset();
                _isNavigating = false;
              }
            });
          });
        }

        if (!_isNavigating &&
            authViewModel.isOtpVerified &&
            !authViewModel.isLoading) {
          _isNavigating = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.goToRole();
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                authViewModel.reset();
                _isNavigating = false;
              }
            });
          });
        }

        return Consumer<DashboardViewModel>(
          builder: (context, dashboardViewModel, _) {
            // Navigate to Role when logged out
            if (dashboardViewModel.isLoggedOut &&
                !dashboardViewModel.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                NavigationService.goToRole();
                dashboardViewModel.resetRole();
              });
            }
            return widget.child;
          },
        );
      },
    );
  }
}

class MultiConsumer extends StatelessWidget {
  final List<Widget> children;
  final Widget child;

  const MultiConsumer({super.key, required this.children, required this.child});

  @override
  Widget build(BuildContext context) {
    Widget currentChild = child;
    for (final consumer in children.reversed) {
      currentChild = Stack(children: [currentChild, consumer]);
    }
    return currentChild;
  }
}
