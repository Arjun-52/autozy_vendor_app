import 'package:autozy_vendor_app/core/utils/top_status_banner.dart';
import 'package:autozy_vendor_app/views/detailer/widgets/dashboard_status_row.dart';
import 'package:autozy_vendor_app/views/detailer/widgets/jobs_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/job_details_bottom_sheet.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';

class DetailerDashboard extends StatefulWidget {
  const DetailerDashboard({super.key});

  @override
  State<DetailerDashboard> createState() => _DetailerDashboardState();
}

class _DetailerDashboardState extends State<DetailerDashboard> {
  bool isOnline = false;

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

    if (job == null) return;

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
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 5,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
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
            Text("Detailer Mode", style: AppStyles.titleMedium),
            Text("Today's Route", style: AppStyles.smallMedium),
          ],
        ),

        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isOnline = !isOnline;
              });

              handleOnlineToggle(context, isOnline); // ✅ ADD THIS LINE
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

      body: Padding(
        padding: AppSpacing.all16,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.custom10),

            const DashboardStatusRow(),

            const SizedBox(height: AppSpacing.custom40),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Today's Jobs", style: AppStyles.sectionTitle),
            ),

            const SizedBox(height: AppSpacing.custom10),

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
