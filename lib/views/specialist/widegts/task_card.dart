import 'package:autozy_vendor_app/views/specialist/widegts/job_details_sheet_.dart';
import 'package:autozy_vendor_app/views/specialist/widegts/completed_task_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/specialist_tasks_viewmodel.dart';

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
  void _showJobDetails(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return JobDetailsSheet(task: task);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: task.isCompleted
          ? CompletedTaskCard(task: task)
          : _buildActiveTaskCard(context),
    );
  }

  Widget _buildActiveTaskCard(BuildContext context) {
    return Container(
      key: ValueKey('active_${task.vehicle}'),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6E3B4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car),
              ),
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.vehicle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    task.title,
                    style: const TextStyle(
                      color: Color(0xff7E8392),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              if (task.isStarted && !task.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffD79306).withAlpha(12),
                    border: Border.all(color: Color(0xffD79306)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: Color(0xffD79306),
                      ),
                      SizedBox(width: 4),
                      Text("00:54", style: TextStyle(color: Color(0xffD79306))),
                    ],
                  ),
                ),

              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  _showJobDetails(context, task);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// STEPS
          ...task.steps.asMap().entries.map((entry) {
            final stepIndex = entry.key;
            final step = entry.value;
            final isStepCompleted =
                stepIndex < task.stepCompleted.length &&
                task.stepCompleted[stepIndex];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: GestureDetector(
                onTap: () => onToggleStep?.call(stepIndex),
                child: Row(
                  children: [
                    Icon(
                      isStepCompleted
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 18,
                      color: isStepCompleted
                          ? Colors.green
                          : const Color(0xff7E8392),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      step,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        decoration: isStepCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: Color(0xff7E8392),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 14),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.timer_outlined, color: Colors.black),
              label: Text(
                task.isStarted ? "Complete Job" : "Start Job",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCB2F),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: task.isCompleted
                  ? null
                  : () {
                      if (!task.isStarted) {
                        onStart();
                      } else {
                        final viewModel = context
                            .read<SpecialistTasksViewModel>();
                        if (!viewModel.areAllStepsCompleted(taskIndex)) {
                          viewModel.showErrorAlert();
                        } else {
                          onComplete();
                        }
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}
