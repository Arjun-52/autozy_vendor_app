import '../../core/interfaces/job_details_repository_interface.dart';
import '../services/new_api_service.dart';
import 'package:flutter/foundation.dart';

class JobDetailsRepository implements IJobDetailsRepository {
  final NewApiService _apiService;

  JobDetailsRepository(this._apiService);

  @override
  Future<Map<String, String>> getJobDetails(String jobId) async {
    try {
      // If it looks like mock fallback ID rather than a UUID, return mock details
      if (jobId.contains(' ') || jobId.length < 15) {
        return _getFallbackDetails(jobId);
      }
      
      final response = await _apiService.getJobDetails(jobId);
      if (response != null && response is Map<String, dynamic> && response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>?;
        if (data != null) {
          final vehicleJson = data['vehicle'] as Map<String, dynamic>?;
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
          final backendStatus = data['status']?.toString().toUpperCase();
          String status = 'Pending';
          if (backendStatus == 'CLEANED') {
            status = 'Completed';
          } else if (backendStatus == 'CNA') {
            status = 'Car Not Available';
          }

          return {
            'vehicleNumber': vehicleJson?['vehicle_number'] ?? 'Unknown Vehicle',
            'customerName': userJson?['name'] ?? 'Customer',
            'location': location,
            'phone': userJson?['phone'] ?? '',
            'status': status,
            'vehicleImage': vehicleJson?['vehicle_image'] ?? '',
          };
        }
      }
      return _getFallbackDetails(jobId);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching job details: $e');
      }
      return _getFallbackDetails(jobId);
    }
  }

  Map<String, String> _getFallbackDetails(String vehicleNumber) {
    return {
      'vehicleNumber': vehicleNumber.contains('-') ? 'TS 01 AB 1234' : vehicleNumber,
      'customerName': "Rahul S.",
      'location': "Tower A, Slot 6",
      'phone': "9145679913",
      'status': "Pending",
      'vehicleImage': "https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=500",
    };
  }

  @override
  Future<bool> uploadPhoto(String vehicleNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<bool> callOwner(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
