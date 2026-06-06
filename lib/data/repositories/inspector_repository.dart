import 'package:flutter/foundation.dart';
import '../../core/interfaces/inspector_repository_interface.dart';
import '../../data/models/inspection_model.dart';
import '../../data/models/inspection_queue_response.dart';
import '../../data/models/inspection_subscription_response.dart';
import '../services/new_api_service.dart';

/// Implementation of InspectorRepository connecting to NewApiService
class InspectorRepository implements IInspectorRepository {
  final NewApiService _apiService;

  InspectorRepository(this._apiService);

  @override
  Future<List<InspectionModel>> getInspections() async {
    if (kDebugMode) {
      print('API request start: getInspectionQueue');
    }
    try {
      final response = await _apiService.getInspectionQueue();
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        throw Exception("Null response received");
      }

      try {
        final parsedResponse = InspectionQueueResponse.fromJson(response as Map<String, dynamic>);
        if (kDebugMode) {
          print('Parsing success: getInspectionQueue');
        }
        return parsedResponse.data;
      } catch (e) {
        if (kDebugMode) {
          print('Parsing failure: $e');
        }
        throw Exception("Failed to parse response: $e");
      }
    } catch (e) {
      if (kDebugMode) {
        print('API request error: $e');
      }
      return [];
    }
  }

  @override
  Future<bool> approveInspection(String inspectionId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // Always succeed for now
  }

  @override
  Future<bool> flagInspection(String inspectionId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // Always succeed for now
  }

  @override
  Future<bool> addPhoto(String inspectionId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 200));
    return true; // Always succeed for now
  }

  @override
  Future<bool> resetInspection(String inspectionId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // Always succeed for now
  }

  @override
  Future<bool> startInspection(String inspectionId) async {
    if (kDebugMode) {
      print('Start Inspection request start');
      print('Inspection ID being sent: $inspectionId');
    }
    try {
      final response = await _apiService.startInspection(inspectionId);
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        throw Exception("Null response received");
      }

      final isSuccess = response['success'] == true;
      if (isSuccess) {
        if (kDebugMode) {
          print('Parsing success: startInspection');
        }
        return true;
      } else {
        throw Exception("API returned unsuccessful status");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Parsing failure: $e');
      }
      rethrow;
    }
  }

  @override
  Future<InspectionModel> completeInspection(String inspectionId, List<Map<String, dynamic>> photos) async {
    if (kDebugMode) {
      print('Complete Inspection request start');
      print('Inspection ID being sent: $inspectionId');
      print('Photos payload being sent: $photos');
    }
    try {
      final response = await _apiService.completeInspection(inspectionId, {'photos': photos});
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        throw Exception("Null response received");
      }

      final isSuccess = response['success'] == true;
      if (isSuccess && response['data'] != null) {
        try {
          final parsed = InspectionModel.fromJson(response['data'] as Map<String, dynamic>);
          if (kDebugMode) {
            print('Parsing success: completeInspection');
          }
          return parsed;
        } catch (e) {
          if (kDebugMode) {
            print('Parsing failure: $e');
          }
          throw Exception("Parsing failure: $e");
        }
      } else {
        throw Exception("API returned unsuccessful status");
      }
    } catch (e) {
      if (kDebugMode) {
        print('API request error: $e');
      }
      rethrow;
    }
  }

  @override
  Future<InspectionModel> failInspection(String inspectionId, String reason, List<String> photos) async {
    if (kDebugMode) {
      print('Fail Inspection request start');
      print('Inspection ID being sent: $inspectionId');
      print('Reason being sent: $reason');
      print('Photos payload being sent: $photos');
    }
    try {
      final response = await _apiService.failInspection(inspectionId, {
        'reason': reason,
        'photos': photos,
      });
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        throw Exception("Null response received");
      }

      final isSuccess = response['success'] == true;
      if (isSuccess && response['data'] != null) {
        try {
          final parsed = InspectionModel.fromJson(response['data'] as Map<String, dynamic>);
          if (kDebugMode) {
            print('Parsing success: failInspection');
          }
          return parsed;
        } catch (e) {
          if (kDebugMode) {
            print('Parsing failure: $e');
          }
          throw Exception("Parsing failure: $e");
        }
      } else {
        throw Exception("API returned unsuccessful status");
      }
    } catch (e) {
      if (kDebugMode) {
        print('API request error: $e');
      }
      rethrow;
    }
  }

  @override
  Future<InspectionModel?> getInspectionBySubscription(String subscriptionId) async {
    if (kDebugMode) {
      print('Get Inspection request start');
      print('Subscription ID being sent: $subscriptionId');
    }
    try {
      final response = await _apiService.getInspectionBySubscription(subscriptionId);
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        if (kDebugMode) {
          print('Null response received');
        }
        return null;
      }

      try {
        final parsedResponse = InspectionSubscriptionResponse.fromJson(response as Map<String, dynamic>);
        if (kDebugMode) {
          print('Parsing success: getInspectionBySubscription');
        }
        if (parsedResponse.data == null) {
          if (kDebugMode) {
            print('Null inspection received');
          }
        }
        return parsedResponse.data;
      } catch (e) {
        if (kDebugMode) {
          print('Parsing failure: $e');
        }
        throw Exception("Failed to parse response: $e");
      }
    } catch (e) {
      if (kDebugMode) {
        print('API request error: $e');
      }
      rethrow;
    }
  }
}
