import 'package:autozy_vendor_app/viewmodels/supervisor_viewmodel.dart';
import 'package:autozy_vendor_app/views/supervisor/widgets/alert_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../widgets/team_status_card.dart';
import '../widgets/tab_button.dart';
import '../widgets/member_card.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';

class SupervisorScreen extends StatelessWidget {
  const SupervisorScreen({super.key});

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
        backgroundColor: AppColors.backgroundLight,

        body: SafeArea(
          child: Padding(
            padding: AppSpacing.all16,
            child: Column(
              children: [
                /// HEADER
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(width: AppSpacing.xs),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Supervisor Mode", style: AppStyles.titleMedium),
                        Text("Team Overview", style: AppStyles.smallMedium),
                      ],
                    ),

                    const Spacer(),

                    /// ONLINE BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        border: Border.all(
                          color: AppColors.successDark.withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        "● Online",
                        style: AppStyles.smallSemiBold,
                      ),
                    ),
                  ],
                ),

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
                          itemBuilder: (_, i) =>
                              MemberCard(member: vm.members[i]),
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
