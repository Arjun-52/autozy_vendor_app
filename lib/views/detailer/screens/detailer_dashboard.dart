import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/status_card.dart';
import '../widgets/job_card.dart';
import '../widgets/job_details_bottom_sheet.dart';
import '../../../core/services/navigation_service.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';

class DetailerDashboard extends StatefulWidget {
  const DetailerDashboard({super.key});

  @override
  State<DetailerDashboard> createState() => _DetailerDashboardState();
}

class _DetailerDashboardState extends State<DetailerDashboard> {
  @override
  void initState() {
    super.initState();
    // Load jobs when dashboard is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<DashboardViewModel>();
      vm.loadJobs();
    });
  }

  void openJobDetails(BuildContext context, int jobIndex) {
    final vm = context.read<DashboardViewModel>();
    final job = vm.getJob(jobIndex);

    if (job == null) {
      print('Job not found at index $jobIndex');
      return;
    }

    print('Job Phone: ${job.phone}');
    print('Job Vehicle: ${job.vehicle}');
    print('Job Name: ${job.name}');
    print('Job Location: ${job.location}');
    showModalBottomSheet(
      context: context,
      builder: (_) => JobDetailsBottomSheet(
        job: job,
        vehicle: job.vehicle,
        name: job.name,
        location: job.location,
        phone: job.phone,
        isCNA: job.isCNA,
        index: jobIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (NavigationService.context != null &&
                Navigator.canPop(NavigationService.context!)) {
              NavigationService.pop();
            } else {
              NavigationService.goToRole();
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
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              "Today's Route",
              style: TextStyle(
                color: Color(0xff7E8392),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffE4FFF2).withValues(alpha: 0.50),
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "● Online",
              style: TextStyle(
                color: Color(0xff008847),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Row(
              children: const [
                Expanded(
                  child: StatusCard(
                    icon: Icons.directions_car,
                    title: "3/40",
                    subtitle: "Completed",
                  ),
                ),
                SizedBox(width: 8),

                Expanded(
                  child: StatusCard(
                    icon: Icons.directions_car,
                    title: "37",
                    subtitle: "Remaining",
                  ),
                ),
                SizedBox(width: 8),

                Expanded(
                  child: StatusCard(
                    icon: Icons.warning_amber_rounded,
                    title: "0",
                    subtitle: "CNA",
                    iconColor: Colors.orange,
                  ),
                ),
                SizedBox(width: 8),

                Expanded(
                  child: StatusCard(
                    icon: Icons.wifi_off,
                    title: "",
                    subtitle: "Offline Ready",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Jobs",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Consumer<DashboardViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.jobs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No jobs available",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 30),
                    itemCount: viewModel.jobs.length,
                    itemBuilder: (context, index) {
                      final job = viewModel.jobs[index];
                      return JobCard(
                        key: ValueKey(job.vehicle),
                        vehicle: job.vehicle,
                        name: job.name,
                        location: job.location,
                        isCompleted: job.isCompleted,
                        isCNA: job.isCNA,
                        index: index,
                        onTap: () => openJobDetails(context, index),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
