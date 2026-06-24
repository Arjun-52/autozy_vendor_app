import '../../data/models/job_model.dart';

abstract class IDashboardRepository {
  Future<List<JobModel>> getJobs();
  Future<bool> markJobCompleted(String vehicleId);
  Future<bool> markJobCNA(String vehicleId);
  Future<bool> startJobCleaning(String vehicleId);
  Future<bool> undoJobStatus(String vehicleId);
  Future<bool> saveJobRemark(String vehicleId, String? reason, String? comment);
  Future<bool> updateJobRemark(String remarkId, String? reason, String? comment);
  Future<Map<String, dynamic>> getDashboardStats();
}
