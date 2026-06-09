import 'package:autozy_vendor_app/core/utils/top_status_banner.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/task_status_tile.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/task_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/services/navigation_service.dart';

import '../../../viewmodels/specialist_tasks_viewmodel.dart';
import '../../../core/services/alert_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/di/dependency_injection.dart';

class SpecialistModeScreen extends StatefulWidget {
  const SpecialistModeScreen({super.key});

  @override
  State<SpecialistModeScreen> createState() => _SpecialistModeScreenState();
}

class _SpecialistModeScreenState extends State<SpecialistModeScreen> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpecialistTasksViewModel(di.specialistTasksRepository)
        ..loadTasks()
        ..fetchSpecialistJobs()
        ..fetchAddonServices()
        ..fetchAddonBookings(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () {
                NavigationService.goBack();
              },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Specialist Mode", style: AppStyles.subHeading),
              Text("Add-on Tasks", style: AppStyles.caption),
            ],
          ),
          actions: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isOnline = !isOnline;
                  });

                  handleOnlineToggle(context, isOnline);
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
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.black),
                onPressed: () {
                  NavigationService.logout();
                },
              ),
            ]
        ),
        body: SafeArea(
          child: Consumer<SpecialistTasksViewModel>(
            builder: (context, vm, child) {
              if (vm.showError && vm.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AlertService.showTopAlert(
                    context,
                    message: vm.errorMessage!,
                    onClose: () => vm.clearError(),
                  );
                });
              }

              return Column(
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  /// STATUS TILES
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        TaskStatusTile(count: "3", label: "Active"),
                        TaskStatusTile(
                          count: "1",
                          label: "In Progress",
                          highlight: true,
                        ),
                        TaskStatusTile(count: "2", label: "Queued"),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  /// LIST
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      children: [
                        const Text(
                          "Add-on Tasks",
                          style: AppStyles.sectionTitle,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (vm.isLoadingJobs)
                          const Center(child: CircularProgressIndicator())
                        else if (vm.specialistJobs.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "No specialist jobs available",
                                style: AppStyles.body,
                              ),
                            ),
                          )
                        else
                          ...List.generate(vm.specialistJobs.length, (index) {
                            final job = vm.specialistJobs[index];
                            final task = job.toTask();

                            return TaskCard(
                              task: task,
                              taskIndex: index,
                              onStart: () => vm.startJob(index),
                              onComplete: () => vm.completeJob(index),
                              onToggleStep: (stepIndex) =>
                                  vm.toggleStep(index, stepIndex),
                            );
                          }),
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: AppSpacing.lg),
                        const Text(
                          "Available Services",
                          style: AppStyles.sectionTitle,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (vm.isLoadingAddonServices)
                          const Center(child: CircularProgressIndicator())
                        else if (vm.addonServices.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "No services available",
                                style: AppStyles.body,
                              ),
                            ),
                          )
                        else
                          ...vm.addonServices.map((service) {
                            final isSelected = vm.selectedPricingId == service.pricingId;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () => vm.selectService(service.pricingId),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            service.name,
                                            style: AppStyles.bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "₹${service.price}",
                                          style: AppStyles.bodyMedium.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      service.description,
                                      style: AppStyles.caption.copyWith(color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time, size: 16, color: AppColors.grey600),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${service.estimatedDuration} mins",
                                              style: AppStyles.caption,
                                            ),
                                          ],
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check_circle,
                                            color: AppColors.primary,
                                          )
                                        else
                                          Text(
                                            "Tap to select",
                                            style: AppStyles.caption.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: AppSpacing.lg),
                        const Text(
                          "My Bookings",
                          style: AppStyles.sectionTitle,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (vm.isLoadingBookings)
                          const Center(child: CircularProgressIndicator())
                        else if (vm.addonBookings.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "No bookings available",
                                style: AppStyles.body,
                              ),
                            ),
                          )
                        else
                          ...vm.addonBookings.map((booking) {
                            return Container();
                          }),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
