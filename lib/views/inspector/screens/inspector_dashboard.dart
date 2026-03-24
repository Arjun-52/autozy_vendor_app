import 'package:autozy_vendor_app/views/inspector/widgets/inspector_card.dart';
import 'package:autozy_vendor_app/views/dashboard/widgets/status_card.dart';
import 'package:flutter/material.dart';

class InspectorDashboard extends StatelessWidget {
  const InspectorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Inspector Mode",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Inspection Queue",
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
            child: const Text(
              "• Online",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: StatusCard(
                    icon: Icons.directions_car,
                    title: "1",
                    subtitle: "Approved",
                    iconColor: Colors.green,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatusCard(
                    icon: Icons.directions_car,
                    title: "2",
                    subtitle: "Pending",
                    iconColor: Colors.orange,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatusCard(
                    icon: Icons.warning,
                    title: "0",
                    subtitle: "Flagged",
                    iconColor: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Inspection Queue",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: const [
                  InspectorCard(),
                  InspectorCard(isApproved: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
