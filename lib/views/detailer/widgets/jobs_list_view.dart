import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import 'job_card.dart';

class JobsListView extends StatelessWidget {
  final Function(int) onTap;

  const JobsListView({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
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
              onTap: () => onTap(index),
            );
          },
        );
      },
    );
  }
}
