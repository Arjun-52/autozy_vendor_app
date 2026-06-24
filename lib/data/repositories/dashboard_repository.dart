import '../../data/models/job_model.dart';
import '../services/new_api_service.dart';
import '../../core/interfaces/dashboard_repository_interface.dart';
import 'package:flutter/foundation.dart';

/// Repository for dashboard-related data operations
/// Acts as a bridge between ViewModel and API service
class DashboardRepository implements IDashboardRepository {
  final NewApiService _apiService;

  DashboardRepository(this._apiService);

  /// Fetch jobs from API
  @override
  Future<List<JobModel>> getJobs() async {
    try {
      final response = await _apiService.getJobs();
      if (response != null && response is Map<String, dynamic> && response['success'] == true) {
        final List<dynamic> list = response['data'] ?? [];
        return list.map((json) => JobModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return _getFallbackJobs();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching jobs: $e');
      }
      // Return fallback data on any error
      return _getFallbackJobs();
    }
  }

  /// Update job status
  Future<bool> updateJobStatus(String vehicleId, String status) async {
    try {
      final response = await _apiService.updateJobStatus(
        vehicleId,
        {'status': status},
      );
      return response != null && response['success'] == true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating job status: $e');
      }
      return true; // Return true as fallback for mock/local development
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

  /// Start cleaning job
  @override
  Future<bool> startJobCleaning(String vehicleId) async {
    return updateJobStatus(vehicleId, 'cleaning');
  }

  /// Undo job status back to pending
  @override
  Future<bool> undoJobStatus(String vehicleId) async {
    return updateJobStatus(vehicleId, 'pending');
  }

  @override
  Future<bool> saveJobRemark(String vehicleId, String? reason, String? comment) async {
    try {
      final response = await _apiService.addComment(
        vehicleId,
        {
          'reason': reason,
          'remark': comment,
        },
      );
      return response != null && response['success'] == true;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving job remark: $e');
      }
      return true; // Return true as fallback for mock/local development
    }
  }

  @override
  Future<bool> updateJobRemark(String remarkId, String? reason, String? comment) async {
    try {
      final response = await _apiService.addComment(
        remarkId,
        {
          'reason': reason,
          'remark': comment,
        },
      );
      return response != null && response['success'] == true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating job remark: $e');
      }
      return true; // Return true as fallback
    }
  }

  /// Fetch dashboard stats from API
  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _apiService.getDashboardStats();
      if (response != null && response is Map<String, dynamic> && response['success'] == true) {
        return response['data'] ?? response;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching dashboard stats: $e');
      }
    }
    // Mock/fallback dashboard stats
    return {
      'completed': 3,
      'total': 40,
      'remaining': 37,
      'cna': 0,
    };
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
        vehicleImage: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=500",
      ),
      JobModel(
        vehicle: "MH 03 CD 5678",
        name: "Priya N.",
        location: "Tower B, Slot 5",
        phone: "+91 87654 32109",
        status: JobStatus.pending,
        vehicleImage: "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=500",
      ),
      JobModel(
        vehicle: "MH 04 EF 9012",
        name: "Amit K.",
        location: "Tower B, Slot 8",
        phone: "+91 76543 21098",
        status: JobStatus.pending,
        vehicleImage: null, // Test missing fallback
      ),
    ];
  }
}
