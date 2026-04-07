import '../../data/models/job_model.dart';
import '../services/api_service.dart';
import '../../core/interfaces/dashboard_repository_interface.dart';

/// Repository for dashboard-related data operations
/// Acts as a bridge between ViewModel and API service
class DashboardRepository implements IDashboardRepository {
  final ApiService _apiService;

  DashboardRepository(this._apiService);

  /// Fetch jobs from API
  /// Returns mock data for now, ready for real API integration
  @override
  Future<List<JobModel>> getJobs() async {
    try {
      // Always use fallback data for now
      return _getFallbackJobs();
    } catch (e) {
      // Return fallback data on any error
      return _getFallbackJobs();
    }
  }

  /// Update job status (mock implementation)
  Future<bool> updateJobStatus(String vehicleId, String status) async {
    try {
      final response = await _apiService.post(
        '/jobs/$vehicleId/status',
        data: {'status': status},
      );

      return response?['success'] == true;
    } catch (e) {
      // For now, always return true for mock operations
      return true;
    }
  }

  /// Mark job as completed
  @override
  Future<bool> markJobCompleted(String vehicleId) async {
    return updateJobStatus(vehicleId, 'completed');
  }

  /// Mark job as CNA (Car Not Available)
  @override
  Future<bool> markJobCNA(String vehicleId) async {
    return updateJobStatus(vehicleId, 'cna');
  }

  /// Undo job status back to pending
  @override
  Future<bool> undoJobStatus(String vehicleId) async {
    return updateJobStatus(vehicleId, 'pending');
  }

  /// Parse string status to JobStatus enum
  JobStatus _parseJobStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return JobStatus.completed;
      case 'cna':
        return JobStatus.cna;
      case 'pending':
      default:
        return JobStatus.pending;
    }
  }

  /// Fallback data when API fails
  List<JobModel> _getFallbackJobs() {
    return [
      JobModel(
        vehicle: "TS 01 AB 1234",
        name: "Rahul S.",
        location: "Tower A, Slot 6",
        phone: "+91 98765 43210",
        status: JobStatus.pending,
      ),
      JobModel(
        vehicle: "MH 03 CD 5678",
        name: "Priya N.",
        location: "Tower B, Slot 5",
        phone: "+91 87654 32109",
        status: JobStatus.pending,
      ),
      JobModel(
        vehicle: "MH 04 EF 9012",
        name: "Amit K.",
        location: "Tower B, Slot 8",
        phone: "+91 76543 21098",
        status: JobStatus.pending,
      ),
    ];
  }
}
