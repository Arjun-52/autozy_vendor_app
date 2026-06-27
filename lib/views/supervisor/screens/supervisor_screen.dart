import 'package:autozy_vendor_app/core/utils/top_status_banner.dart';
import 'package:autozy_vendor_app/viewmodels/supervisor_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/attendance_viewmodel.dart';
import 'package:autozy_vendor_app/views/supervisor/widgets/alert_card.dart';
import 'package:autozy_vendor_app/views/supervisor/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/service_record_card.dart';

import '../widgets/team_status_card.dart';
import '../widgets/tab_button.dart';
import '../widgets/member_card.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/services/navigation_service.dart';

class SupervisorScreen extends StatefulWidget {
  const SupervisorScreen({super.key});

  @override
  State<SupervisorScreen> createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  String? _lastAttendanceError;
  final ScrollController _notificationsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Load data from repository
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<SupervisorViewModel>();
      vm.loadData();
      vm.addListener(_onViewModelChanged);
      _notificationsScrollController.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    _notificationsScrollController.removeListener(_onScroll);
    _notificationsScrollController.dispose();
    context.read<SupervisorViewModel>().removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onScroll() {
    final vm = context.read<SupervisorViewModel>();
    if (_notificationsScrollController.position.pixels >=
        _notificationsScrollController.position.maxScrollExtent - 200) {
      if (!vm.isLoadingNotifications && vm.notificationsError == null) {
        vm.fetchNotifications();
      }
    }
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    final vm = context.read<SupervisorViewModel>();
    if (vm.attendanceError != _lastAttendanceError) {
      _lastAttendanceError = vm.attendanceError;
      if (_lastAttendanceError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Attendance Error: $_lastAttendanceError"),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: "Retry",
              textColor: Colors.white,
              onPressed: () {
                vm.fetchAttendance();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SupervisorViewModel>();
    final attendanceVm = context.watch<AttendanceViewModel>();
    final isOnline = attendanceVm.attendance != null;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () {
              NavigationService.goToLogin();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Supervisor Mode", style: AppStyles.subHeading),
              Text("Team Overview", style: AppStyles.caption),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (!isOnline) {
                  context.push('/profile');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please Clock In to go Online')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please Clock Out from Profile to go Offline')),
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: AppSpacing.right16,
                padding: AppSpacing.horizontal12Vertical6,
                decoration: BoxDecoration(
                  color: isOnline
                      ? AppColors.onlineBg.withOpacity(0.5)
                      : Colors.red.withOpacity(0.1),
                  border: Border.all(
                    color: isOnline ? AppColors.success : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Text(
                  isOnline ? "● Online" : "● Offline",
                  style: TextStyle(
                    color: isOnline ? AppColors.success : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: AppColors.black),
              onPressed: () {
                context.push('/profile');
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.black),
              onPressed: () {
                NavigationService.logout();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.all16,
            child: Column(
              children: [
                /// HEADER
                const SizedBox(height: AppSpacing.md),

                /// STATUS CARDS
                Row(
                  children: [
                    Expanded(
                      child: TeamStatusCard(
                        icon: SvgPicture.asset(
                          "assets/images/user.svg",
                          height: AppSpacing.lg,
                          width: AppSpacing.lg,
                        ),
                        title: vm.activeCount.toString(),
                        subtitle: "Active",
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),

                    Expanded(
                      child: TeamStatusCard(
                        icon: SvgPicture.asset(
                          "assets/images/user.svg",
                          height: AppSpacing.lg,
                          width: AppSpacing.lg,
                        ),
                        title: vm.breakCount.toString(),
                        subtitle: "On Break",
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),

                    Expanded(
                      child: TeamStatusCard(
                        icon: SvgPicture.asset(
                          "assets/images/user.svg",
                          height: AppSpacing.lg,
                          width: AppSpacing.lg,
                          colorFilter: const ColorFilter.mode(
                            AppColors.error,
                            BlendMode.srcIn,
                          ),
                        ),
                        title: vm.offlineCount.toString(),
                        subtitle: "Offline",
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                /// TABS
                Row(
                  children: [
                    TabButton(
                      text: "Team",
                      icon: Icons.groups,
                      selected: vm.currentTab == SupervisorTab.team,
                      onTap: () => vm.switchTab(SupervisorTab.team),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    TabButton(
                      text: "Alerts (${vm.unreadNotificationsCount})",
                      icon: Icons.notifications_none,
                      selected: vm.currentTab == SupervisorTab.alerts,
                      onTap: () => vm.switchTab(SupervisorTab.alerts),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    TabButton(
                      text: "Records",
                      icon: Icons.assignment_outlined,
                      selected: vm.currentTab == SupervisorTab.records,
                      onTap: () => vm.switchTab(SupervisorTab.records),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                /// LIST
                Expanded(
                  child: vm.currentTab == SupervisorTab.team
                      ? ListView.builder(
                          itemCount: vm.members.length,
                          itemBuilder: (_, i) => MemberCard(
                            name: vm.members[i].name,
                            role: vm.members[i].role,
                            tower: vm.members[i].tower,
                            status: vm.members[i].status,
                            completed: vm.members[i].completed,
                            total: vm.members[i].total,
                            phone: vm.members[i].phone,
                            hideProgress: vm.members[i].role.trim().toLowerCase() == 'inspector',
                          ),
                        )
                      : vm.currentTab == SupervisorTab.alerts
                          ? _buildNotificationsSection(vm)
                          : _buildServiceRecordsSection(vm),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceRecordsSection(SupervisorViewModel vm) {
    if (vm.isLoadingServiceRecords) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (vm.serviceRecordsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              "Failed to load service records",
              style: AppStyles.subHeading.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => vm.fetchServiceRecords(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (vm.serviceRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined, size: 64, color: AppColors.textPrimary.withOpacity(0.4)),
            const SizedBox(height: 16),
            const Text(
              "No Service Records Available",
              style: AppStyles.subHeading,
            ),
            const SizedBox(height: 8),
            Text(
              "Daily wash/service jobs will appear here.",
              style: AppStyles.caption.copyWith(color: AppColors.textPrimary.withOpacity(0.6)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: vm.serviceRecords.length,
      itemBuilder: (context, index) {
        final record = vm.serviceRecords[index];
        return ServiceRecordCard(record: Map<String, dynamic>.from(record));
      },
    );
  }

  Widget _buildNotificationsSection(SupervisorViewModel vm) {
    if (vm.isLoadingNotifications && vm.notifications.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (vm.notificationsError != null && vm.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              "Failed to load alerts",
              style: AppStyles.subHeading.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => vm.fetchNotifications(refresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (vm.notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => vm.fetchNotifications(refresh: true),
        color: AppColors.primary,
        child: Stack(
          children: [
            ListView(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textPrimary.withOpacity(0.4)),
                  const SizedBox(height: 16),
                  const Text(
                    "No Alerts Available",
                    style: AppStyles.subHeading,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Any new system alerts will appear here.",
                    style: AppStyles.caption.copyWith(color: AppColors.textPrimary.withOpacity(0.6)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => vm.fetchNotifications(refresh: true),
      color: AppColors.primary,
      child: ListView.builder(
        controller: _notificationsScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: vm.notifications.length + (vm.isLoadingNotifications ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == vm.notifications.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                ),
              ),
            );
          }
          final notification = vm.notifications[index];
          return NotificationCard(
            notification: notification,
            onAcknowledge: () => vm.markAsRead(notification.id),
          );
        },
      ),
    );
  }
}

