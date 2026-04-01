import 'package:autozy_vendor_app/views/specialist/widegts/task_card.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/task_status_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/specialist_tasks_viewmodel.dart';
import '../../../core/services/alert_service.dart';
import '../../../core/constants/app_colors.dart'; // ✅ added

class SpecialistModeScreen extends StatelessWidget {
  const SpecialistModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpecialistTasksViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background, // ✅ changed
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
                  ///  HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/role'),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.textPrimary, // ✅ changed
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Specialist Mode",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary, // ✅ changed
                              ),
                            ),
                            Text(
                              "Add-on Tasks",
                              style: TextStyle(
                                color: AppColors.textMuted, // ✅ changed
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        /// ONLINE BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successLight.withValues(
                              alpha: 0.19,
                            ), // ✅ changed
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.successDark, // ✅ changed
                            ),
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor:
                                    AppColors.successDark, // ✅ changed
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Online",
                                style: TextStyle(
                                  color: AppColors.successDark, // ✅ changed
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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

                  const SizedBox(height: 20),

                  /// LIST
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        const Text(
                          "Add-on Tasks",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary, // ✅ changed
                          ),
                        ),
                        const SizedBox(height: 16),

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
