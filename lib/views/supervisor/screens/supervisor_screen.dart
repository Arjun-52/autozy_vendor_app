import 'package:autozy_vendor_app/viewmodels/supervisor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/team_status_card.dart';
import '../widgets/tab_button.dart';
import '../widgets/member_card.dart';

class SupervisorScreen extends StatelessWidget {
  const SupervisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SupervisorViewModel>();

    return Scaffold(
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Team Overview",
                        style: TextStyle(color: Colors.grey),
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
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "● Online",
                      style: TextStyle(color: Colors.green),
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
                      icon: Icons.person_outline,
                      title: vm.activeCount.toString(),
                      subtitle: "Active",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: TeamStatusCard(
                      icon: Icons.person_outline,
                      title: vm.breakCount.toString(),
                      subtitle: "On Break",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: TeamStatusCard(
                      icon: Icons.person_outline,
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
                children: const [
                  TabButton(text: "Team", selected: true),
                  SizedBox(width: 10),
                  TabButton(text: "Alerts (3)", selected: false),
                ],
              ),

              const SizedBox(height: 16),

              //  LIST
              Expanded(
                child: ListView.builder(
                  itemCount: vm.members.length,
                  itemBuilder: (context, index) {
                    final member = vm.members[index];
                    return MemberCard(member: member);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
