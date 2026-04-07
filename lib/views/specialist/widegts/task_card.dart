import 'package:autozy_vendor_app/views/specialist/widegts/job_details_sheet_.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/completed_task_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/specialist_tasks_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/task_model.dart';

import 'task_card_header.dart';
import 'task_steps_list.dart';
import 'task_action_button.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final int taskIndex;
  final VoidCallback onStart;
  final VoidCallback onComplete;
  final Function(int)? onToggleStep;

  const TaskCard({
    super.key,
    required this.task,
    required this.taskIndex,
    required this.onStart,
    required this.onComplete,
    this.onToggleStep,
  });

  void _showJobDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => JobDetailsSheet(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: task.isCompleted
          ? CompletedTaskCard(task: task)
          : _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    final vm = context.read<SpecialistTasksViewModel>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskCardHeader(
            vehicle: task.vehicle,
            title: task.title,
            showTimer: task.isStarted && !task.isCompleted,
            onTap: () => _showJobDetails(context),
          ),

          const SizedBox(height: 12),

          TaskStepsList(
            steps: task.steps,
            completed: task.stepCompleted,
            onTap: onToggleStep,
          ),

          const SizedBox(height: 14),

          TaskActionButton(
            isStarted: task.isStarted,
            onPressed: task.isCompleted
                ? () {}
                : () {
                    if (!task.isStarted) {
                      onStart();
                    } else {
                      if (!vm.areAllStepsCompleted(taskIndex)) {
                        vm.showErrorAlert();
                      } else {
                        onComplete();
                      }
                    }
                  },
          ),
        ],
      ),
    );
  }
}
