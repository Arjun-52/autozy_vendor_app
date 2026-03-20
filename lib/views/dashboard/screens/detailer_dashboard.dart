import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../widgets/status_card.dart';
import '../widgets/job_card.dart';

class DetailerDashboard extends StatelessWidget {
  const DetailerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              context.pop();
            } else {
              context.go('/role');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Detailer Mode",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Today’s Route",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Online", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: StatusCard(
                    icon: Icons.directions_car,
                    title: "3/40",
                    subtitle: "Completed",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatusCard(
                    icon: Icons.directions_car,
                    title: "37",
                    subtitle: "Remaining",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatusCard(
                    icon: Icons.wifi_off,
                    title: "",
                    subtitle: "Offline Ready",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today’s Jobs",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 30),
                children: const [
                  JobCard(
                    vehicle: "TS 01 AB 1234",
                    name: "Rahul S.",
                    location: "Nexus Hyderabad, Kukatpally, Hyderabad",
                  ),
                  JobCard(
                    vehicle: "MH 03 CD 5678",
                    name: "Priya M.",
                    location: "Tower B, Slot 5",
                  ),
                  JobCard(
                    vehicle: "MH 04 EF 9012",
                    name: "Ravi K.",
                    location: "Tower B, Slot 8",
                    isCompleted: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
