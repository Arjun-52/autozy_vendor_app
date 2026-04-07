import 'package:autozy_vendor_app/views/specialist/widegts/task_card.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/task_status_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/specialist_tasks_viewmodel.dart';
import '../../../core/services/alert_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/di/dependency_injection.dart';

class SpecialistModeScreen extends StatelessWidget {
  const SpecialistModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpecialistTasksViewModel(di.specialistTasksRepository),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () {
              context.go('/role');
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
            Container(
              margin: AppSpacing.right16,
              padding: AppSpacing.horizontal12Vertical6,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                border: Border.all(
                  color: AppColors.successDark.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: const Text("• Online", style: AppStyles.smallMedium),
            ),
          ],
        ),
        body: SafeArea(
          child: Consumer<SpecialistTasksViewModel>(
            builder: (context, vm, child) {
              // Load tasks when screen is built
              if (vm.tasks.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  vm.loadTasks();
                });
              }

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

                        ...List.generate(vm.tasks.length, (index) {
                          final task = vm.tasks[index];

                          return TaskCard(
                            task: task,
                            taskIndex: index,
                            onStart: () => vm.startJob(index),
                            onComplete: () => vm.completeJob(index),
                            onToggleStep: (stepIndex) =>
                                vm.toggleStep(index, stepIndex),
                          );
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
