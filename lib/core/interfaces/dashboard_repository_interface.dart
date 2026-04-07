import '../../data/models/job_model.dart';

abstract class IDashboardRepository {
  Future<List<JobModel>> getJobs();
  Future<bool> markJobCompleted(String vehicleId);
  Future<bool> markJobCNA(String vehicleId);
  Future<bool> undoJobStatus(String vehicleId);
}
