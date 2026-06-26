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
        if (viewModel.isLoading && viewModel.jobs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (viewModel.errorMessage != null && viewModel.jobs.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => viewModel.loadJobs(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => viewModel.loadJobs(),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (viewModel.jobs.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => viewModel.loadJobs(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                const Center(
                  child: Text(
                    "No jobs available",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.loadJobs(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 30),
            itemCount: viewModel.jobs.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final job = viewModel.jobs[index];
              return JobCard(
                 key: ValueKey(job.id ?? job.vehicle),
                 vehicle: job.vehicle,
                 name: job.name,
                 location: job.location,
                 isCompleted: job.isCompleted,
                 isCNA: job.isCNA,
                 status: job.status,
                 beforeImage: job.beforeImage,
                 vehicleImage: job.vehicleImage,
                 index: index,
                 onTap: () => onTap(index),
               );
            },
          ),
        );
      },
    );
  }
}
