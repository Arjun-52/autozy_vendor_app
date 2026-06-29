import 'package:autozy_vendor_app/core/constants/app_colors.dart';
import 'package:autozy_vendor_app/core/constants/app_spacing.dart';
import 'package:autozy_vendor_app/core/constants/app_styles.dart';
import 'package:autozy_vendor_app/core/services/alert_service.dart';
import 'package:autozy_vendor_app/core/services/navigation_service.dart';
import 'package:autozy_vendor_app/viewmodels/attendance_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/specialist_tasks_viewmodel.dart';
import 'package:autozy_vendor_app/viewmodels/specialist_viewmodel.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/assigned_job_card.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/task_status_tile.dart';
import 'package:autozy_vendor_app/views/specialist/screens/report_issue_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SpecialistModeScreen extends StatefulWidget {
  const SpecialistModeScreen({super.key});

  @override
  State<SpecialistModeScreen> createState() => _SpecialistModeScreenState();
}

class _SpecialistModeScreenState extends State<SpecialistModeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpecialistViewModel>().loadDashboardData();
    });
  }

  int _activeCount(SpecialistViewModel vm) {
    return vm.assignedJobs.where((job) => !job.isCompleted).length;
  }

  int _inProgressCount(SpecialistViewModel vm) {
    return vm.assignedJobs.where((job) => job.isInProgress).length;
  }

  int _queuedCount(SpecialistViewModel vm) {
    return vm.assignedJobs
        .where((job) => job.isAssigned || job.isAccepted)
        .length;
  }

  Widget _buildAssignedJobsState(SpecialistViewModel specialistVm) {
    if (specialistVm.isLoading && specialistVm.assignedJobs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (specialistVm.errorMessage != null &&
        specialistVm.assignedJobs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 52,
            ),
            const SizedBox(height: 12),
            const Text(
              "Unable to load assigned jobs",
              style: AppStyles.subHeading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              specialistVm.errorMessage!,
              style: AppStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: specialistVm.loadAssignedJobs,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (specialistVm.assignedJobs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: AppColors.textPrimary.withOpacity(0.45),
            ),
            const SizedBox(height: 12),
            const Text(
              "No Assigned Jobs",
              style: AppStyles.subHeading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "You don't have any assigned jobs yet.",
              style: AppStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: specialistVm.loadAssignedJobs,
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh"),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (specialistVm.isLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(
              color: AppColors.primary,
              minHeight: 3,
            ),
          ),
        ...specialistVm.assignedJobs.map(
          (job) => AssignedJobCard(job: job),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceVm = context.watch<AttendanceViewModel>();
    final isOnline = attendanceVm.attendance != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: NavigationService.goBack,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Specialist Mode", style: AppStyles.subHeading),
            Text("Assigned Jobs", style: AppStyles.caption),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (!isOnline) {
                context.push('/profile');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please Clock In to go Online')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please Clock Out from Profile to go Offline',
                    ),
                  ),
                );
              }
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
                isOnline ? "Online" : "Offline",
                style: TextStyle(
                  color: isOnline ? AppColors.success : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            tooltip: 'Report Issue',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportIssueScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.black),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.black),
            onPressed: NavigationService.logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer2<SpecialistViewModel, SpecialistTasksViewModel>(
          builder: (context, specialistVm, tasksVm, child) {
            if (tasksVm.showError && tasksVm.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertService.showTopAlert(
                  context,
                  message: tasksVm.errorMessage!,
                  onClose: () => tasksVm.clearError(),
                );
              });
            }

            return Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TaskStatusTile(
                        count: _activeCount(specialistVm).toString(),
                        label: "Active",
                      ),
                      TaskStatusTile(
                        count: _inProgressCount(specialistVm).toString(),
                        label: "In Progress",
                        highlight: true,
                      ),
                      TaskStatusTile(
                        count: _queuedCount(specialistVm).toString(),
                        label: "Queued",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: specialistVm.loadDashboardData,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      children: [
                        const Text(
                          "Your Performance KPIs",
                          style: AppStyles.sectionTitle,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildKpiGrid(specialistVm),
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: AppSpacing.lg),
                        const Text(
                          "Assigned Jobs",
                          style: AppStyles.sectionTitle,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildAssignedJobsState(specialistVm),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildKpiGrid(SpecialistViewModel vm) {
    if (vm.isLoadingKpis && vm.kpis == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    if (vm.kpisErrorMessage != null && vm.kpis == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Failed to load KPIs: ${vm.kpisErrorMessage}",
                style: TextStyle(color: Colors.red.shade800, fontSize: 13),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              onPressed: () => vm.loadKpis(),
            ),
          ],
        ),
      );
    }

    final data = vm.kpis;
    if (data == null) return const SizedBox.shrink();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _kpiCard("Total Jobs", data.totalJobs.toString(), Icons.assignment_outlined, Colors.blue),
        _kpiCard("Completed (Week)", data.completedThisWeek.toString(), Icons.assignment_turned_in_outlined, Colors.green),
        _kpiCard("Rework Rate", "${data.reworkPercent.toDouble().toStringAsFixed(1)}%", Icons.redo_outlined, Colors.orange),
        _kpiCard("Avg Rating", "${data.averageRating.toDouble().toStringAsFixed(1)} ★", Icons.star_outline, Colors.amber),
      ],
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
