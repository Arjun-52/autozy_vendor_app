import 'package:autozy_vendor_app/viewmodels/supervisor_viewmodel.dart';
import 'package:autozy_vendor_app/views/supervisor/widgets/alert_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../widgets/team_status_card.dart';
import '../widgets/tab_button.dart';
import '../widgets/member_card.dart';

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
        backgroundColor: const Color(0xfff5f5f5),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                //  HEADER
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),

                    const SizedBox(width: 4),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Supervisor Mode",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Team Overview",
                          style: TextStyle(
                            color: Color(0xff7E8392),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Online badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xff008847).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Text(
                        "● Online",
                        style: TextStyle(
                          color: Color(0xff008847),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // STATUS CARDS
                Row(
                  children: [
                    Expanded(
                      child: TeamStatusCard(
                        icon: SvgPicture.asset(
                          "assets/images/user.svg",
                          height: 20,
                          width: 20,
                        ),
                        title: vm.activeCount.toString(),
                        subtitle: "Active",
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: TeamStatusCard(
                        icon: SvgPicture.asset(
                          "assets/images/user.svg",
                          height: 20,
                          width: 20,
                        ),
                        title: vm.breakCount.toString(),
                        subtitle: "On Break",
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: TeamStatusCard(
                        icon: SvgPicture.asset(
                          "assets/images/user.svg",
                          height: 20,
                          width: 20,
                          colorFilter: const ColorFilter.mode(
                            Colors.red,
                            BlendMode.srcIn,
                          ),
                        ),
                        title: vm.offlineCount.toString(),
                        subtitle: "Offline",
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // TABS
                Row(
                  children: [
                    TabButton(
                      text: "Team",
                      icon: Icons.groups,
                      selected: vm.currentTab == SupervisorTab.team,
                      onTap: () => vm.switchTab(SupervisorTab.team),
                    ),
                    const SizedBox(width: 10),
                    TabButton(
                      text: "Alerts (3)",
                      icon: Icons.notifications_none,
                      selected: vm.currentTab == SupervisorTab.alerts,
                      onTap: () => vm.switchTab(SupervisorTab.alerts),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                //  LIST
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
