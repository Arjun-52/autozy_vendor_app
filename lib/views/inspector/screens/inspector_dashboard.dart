import 'package:autozy_vendor_app/viewmodels/inspector_viewmodel.dart';
import 'package:autozy_vendor_app/views/inspector/widgets/inspector_card.dart';
import 'package:autozy_vendor_app/views/detailer/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InspectorDashboard extends StatefulWidget {
  const InspectorDashboard({super.key});

  @override
  State<InspectorDashboard> createState() => _InspectorDashboardState();
}

class _InspectorDashboardState extends State<InspectorDashboard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InspectorViewModel>().loadInspections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InspectorViewModel>();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/role');
          },
        ),
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
              color: Color(0xffE4FFF2),
              border: Border.all(
                color: Color(0xff008847).withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "• Online",
              style: TextStyle(
                color: Color(0xff008847),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatusCard(
                    icon: Icons.directions_car,
                    title: vm.approvedCount.toString(),
                    subtitle: "Approved",
                    iconColor: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatusCard(
                    icon: Icons.directions_car,
                    title: vm.pendingCount.toString(),
                    subtitle: "Pending",
                    iconColor: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatusCard(
                    icon: Icons.warning,
                    title: vm.flaggedCount.toString(),
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
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: [
                  ...vm.inspections.asMap().entries.map(
                    (entry) => InspectorCard(
                      inspection: entry.value,
                      index: entry.key,
                    ),
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
