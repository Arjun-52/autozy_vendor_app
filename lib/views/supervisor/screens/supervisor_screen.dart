import 'package:autozy_vendor_app/core/utils/top_status_banner.dart';
import 'package:autozy_vendor_app/viewmodels/supervisor_viewmodel.dart';
import 'package:autozy_vendor_app/views/supervisor/widgets/alert_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/team_status_card.dart';
import '../widgets/tab_button.dart';
import '../widgets/member_card.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';

class SupervisorScreen extends StatefulWidget {
  const SupervisorScreen({super.key});

  @override
  State<SupervisorScreen> createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  bool isOnline = true;

  @override
  void initState() {
    super.initState();

    // Load data from repository
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupervisorViewModel>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SupervisorViewModel>();

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
              context.go('/role');
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
                setState(() {
                  isOnline = !isOnline;
                });

                handleOnlineToggle(context, isOnline);
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
                      text: "Alerts (3)",
                      icon: Icons.notifications_none,
                      selected: vm.currentTab == SupervisorTab.alerts,
                      onTap: () => vm.switchTab(SupervisorTab.alerts),
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
                          ),
                        )
                      : ListView.builder(
                          itemCount: vm.alerts.length,
                          itemBuilder: (_, i) => AlertCard(alert: vm.alerts[i]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
