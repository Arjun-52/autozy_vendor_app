import 'package:autozy_vendor_app/views/detailer/widgets/dashboard_status_row.dart';
import 'package:autozy_vendor_app/views/detailer/widgets/jobs_list_view.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

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

            const DashboardStatusRow(),

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
              child: JobsListView(
                onTap: (index) => openJobDetails(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
