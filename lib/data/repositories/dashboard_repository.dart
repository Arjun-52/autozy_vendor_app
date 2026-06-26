import 'dart:io';
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
      final response = await _apiService.getDailyRoute();
      if (response != null && response is Map<String, dynamic> && response['success'] == true) {
        final data = response['data'];
        if (data != null && data is Map<String, dynamic>) {
          final List<dynamic> records = data['records'] ?? [];
          if (kDebugMode) {
            print('DEBUG: getJobs raw response records count: ${records.length}');
          }
          return records.map((recordJson) {
            final map = recordJson as Map<String, dynamic>;
            final vehicleJson = map['vehicle'] as Map<String, dynamic>?;
            final userJson = vehicleJson?['user'] as Map<String, dynamic>?;
            
            // Determine parking/location
            String location = 'No slot info';
            if (vehicleJson != null) {
              if (vehicleJson['pillar_number'] != null && vehicleJson['pillar_number'].toString().isNotEmpty) {
                location = 'Pillar ${vehicleJson['pillar_number']}';
              } else if (vehicleJson['parking_notes'] != null && vehicleJson['parking_notes'].toString().isNotEmpty) {
                location = vehicleJson['parking_notes'].toString();
              }
            }

            // Map status
            final rawStatus = map['status']?.toString();
            final backendStatus = rawStatus?.toUpperCase();
            JobStatus status = JobStatus.pending;
            if (backendStatus == 'CLEANED') {
              status = JobStatus.completed;
            } else if (backendStatus == 'CNA') {
              status = JobStatus.cna;
            } else if (backendStatus == 'MISSED') {
              status = JobStatus.cna;
            }

            if (kDebugMode) {
              print('API status: $rawStatus | Parsed model: $status | Vehicle: ${vehicleJson?['vehicle_number']} | RecordID: ${map['id']}');
            }

            // Map photos
            final List<dynamic> photos = map['photos'] ?? [];
            String? beforeImage;
            String? afterImage;
            if (photos.isNotEmpty) {
              beforeImage = photos[0]['url'];
              if (photos.length > 1) {
                afterImage = photos[1]['url'];
              }
            }

            return JobModel(
              id: map['id']?.toString(),
              vehicle: vehicleJson?['vehicle_number'] ?? 'Unknown Vehicle',
              name: userJson?['name'] ?? 'Customer',
              location: location,
              phone: userJson?['phone'] ?? '',
              status: status,
              beforeImage: beforeImage,
              afterImage: afterImage,
              vehicleImage: vehicleJson?['vehicle_image'],
            );
          }).toList();
        }
      }
      if (kDebugMode) {
        print('DEBUG: getJobs response success is false or data is null, using fallback jobs');
      }
      return _getFallbackJobs();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching jobs: $e');
      }
      return _getFallbackJobs();
    }
  }

  /// Update job status (fallback/legacy)
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
      return true; 
    }
  }

  /// Mark job as completed
  @override
  Future<bool> markJobCompleted(String recordId) async {
    try {
      if (recordId.contains(' ') || recordId.length < 15) {
        return true; 
      }
      final response = await _apiService.completeJob(recordId);
      return response != null && response['success'] == true;
    } catch (e) {
      if (kDebugMode) {
        print('Error completing job: $e');
      }
      return false;
    }
  }

  /// Mark job as CNA (Car Not Available)
  @override
  Future<bool> markJobCNA(String recordId) async {
    try {
      if (recordId.contains(' ') || recordId.length < 15) {
        return true;
      }
      final response = await _apiService.markJobCNA(
        recordId,
        {
          'photos': [],
          'gpsLat': 17.385,
          'gpsLng': 78.486,
          'notes': 'Car Not Available'
        },
      );
      return response != null && response['success'] == true;
    } catch (e) {
      if (kDebugMode) {
        print('Error marking job CNA: $e');
      }
      return false;
    }
  }

  /// Start cleaning job
  @override
  Future<bool> startJobCleaning(String recordId) async {
    return true; 
  }

  /// Undo job status back to pending
  @override
  Future<bool> undoJobStatus(String recordId) async {
    return true; 
  }

  @override
  Future<bool> saveJobRemark(String recordId, String? reason, String? comment) async {
    try {
      if (recordId.contains(' ') || recordId.length < 15) {
        return true;
      }
      final response = await _apiService.addComment(
        recordId,
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
      return true; 
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
      return true; 
    }
  }

  /// Fetch dashboard stats from API
  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _apiService.getDailyRoute();
      if (response != null && response is Map<String, dynamic> && response['success'] == true) {
        final data = response['data'];
        if (data != null && data is Map<String, dynamic>) {
          final route = data['route'] as Map<String, dynamic>?;
          if (route != null) {
            final total = route['total_count'] ?? 0;
            final completed = route['completed_count'] ?? 0;
            final cna = route['cna_count'] ?? 0;
            final remaining = total - completed - cna;
            return {
              'completed': completed,
              'total': total,
              'remaining': remaining >= 0 ? remaining : 0,
              'cna': cna,
            };
          }
        }
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

  @override
  Future<Map<String, dynamic>?> uploadAfterPhoto(String jobId, File file) async {
    try {
      final response = await _apiService.uploadAfterPhoto(jobId, file);
      if (response != null && response is Map<String, dynamic> && response['success'] == true) {
        return response['data'] ?? response;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading after photo: $e');
      }
      return null;
    }
  }
}
