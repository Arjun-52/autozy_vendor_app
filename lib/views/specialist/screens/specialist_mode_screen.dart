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

class SpecialistModeScreen extends StatelessWidget {
  const SpecialistModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpecialistTasksViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Consumer<SpecialistTasksViewModel>(
            builder: (context, vm, _) {
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
                  /// HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, // 16
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/role'),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(width: AppSpacing.sm),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Specialist Mode",
                              style: AppStyles.titleMedium,
                            ),
                            Text("Add-on Tasks", style: AppStyles.smallMedium),
                          ],
                        ),

                        const Spacer(),

                        /// ONLINE BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successLight.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusLg,
                            ),
                            border: Border.all(color: AppColors.successDark),
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(
                                radius: AppSpacing.xs,
                                backgroundColor: AppColors.successDark,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text("Online", style: AppStyles.smallSemiBold),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

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
