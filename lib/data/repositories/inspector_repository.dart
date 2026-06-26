import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/network/api_client.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/interfaces/inspector_repository_interface.dart';
import '../../data/models/inspection_model.dart';
import '../../data/models/inspection_queue_response.dart';
import '../../data/models/inspection_subscription_response.dart';
import '../../data/models/upload_image_response.dart';
import '../services/new_api_service.dart';

/// Implementation of InspectorRepository connecting to NewApiService
class InspectorRepository implements IInspectorRepository {
  final NewApiService _apiService;

  InspectorRepository(this._apiService);

  @override
  Future<UploadImageResponse> uploadImage(File file) async {
    final int bytes = file.lengthSync();
    final double kb = bytes / 1024;
    final double mb = kb / 1024;
    debugPrint('Image size: $bytes bytes');

    final filename = file.path.split(RegExp(r'[/\\]')).last;
    final extension = filename.split('.').last.toLowerCase();
    final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

    if (kDebugMode) {
      print('API request start: uploadImage');
      print('--- Image Upload Payload Info ---');
      print('File path: ${file.path}');
      print('File size in KB: ${kb.toStringAsFixed(2)} KB');
      print('File size in MB: ${mb.toStringAsFixed(2)} MB');
      print('Multipart field name: file');
      print('Content-Type: $mimeType');
      print('Filename: $filename');
      print('---------------------------------');
    }
    try {
      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: filename,
        contentType: MediaType.parse(mimeType),
      );

      final formData = FormData.fromMap({
        'file': multipartFile,
      });

      if (kDebugMode) {
        print('API request start: uploadImage (direct via Dio)');
      }

      final response = await ApiClient().dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
      );

      if (kDebugMode) {
        print('API response received: ${response.data}');
      }

      if (response.data == null) {
        throw Exception("Null response received");
      }

      try {
        final parsedResponse = UploadImageResponse.fromJson(response.data as Map<String, dynamic>);
        if (kDebugMode) {
          print('Parsing success: uploadImage');
        }
        return parsedResponse;
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

  @override
  Future<List<InspectionModel>> getInspections() async {
    if (kDebugMode) {
      print('API request start: getInspectionQueue');
      print('Endpoint: GET /api/v1/inspections/queue');
      final token = ApiClient().token;
      final role = ApiClient().staffRole;
      print('Inspector token exists: ${token != null}');
      print('Inspector role: $role');
    }
    try {
      final response = await _apiService.getInspectionQueue();
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        print('Response is null.');
        throw Exception("Null response received");
      }

      final Map<String, dynamic> respMap = response as Map<String, dynamic>;

      final Map<String, dynamic> dataMap = respMap['data'] is Map<String, dynamic>
          ? respMap['data'] as Map<String, dynamic>
          : respMap;

      final List<dynamic> assignedRaw = dataMap['assigned'] is List ? dataMap['assigned'] as List : [];
      final List<dynamic> unassignedRaw = dataMap['unassigned'] is List ? dataMap['unassigned'] as List : [];

      if (kDebugMode) {
        print('Raw data.assigned.length immediately after decoding: ${assignedRaw.length}');
        print('Raw data.unassigned.length immediately after decoding: ${unassignedRaw.length}');
        if (assignedRaw.isNotEmpty) {
          print('DEBUG KEYS (assigned): ${(assignedRaw.first as Map<String, dynamic>).keys.toList()}');
        }
        if (unassignedRaw.isNotEmpty) {
          print('DEBUG KEYS (unassigned): ${(unassignedRaw.first as Map<String, dynamic>).keys.toList()}');
        }
      }

      final List<InspectionModel> assigned = [];
      for (final e in assignedRaw) {
        try {
          assigned.add(InspectionModel.fromQueueJson(e as Map<String, dynamic>));
        } catch (err, stack) {
          if (kDebugMode) {
            print('Error parsing assigned element: $err');
            print('Failed element JSON: $e');
            print(stack);
          }
        }
      }

      final List<InspectionModel> unassigned = [];
      for (final e in unassignedRaw) {
        try {
          unassigned.add(InspectionModel.fromQueueJson(e as Map<String, dynamic>));
        } catch (err, stack) {
          if (kDebugMode) {
            print('Error parsing unassigned element: $err');
            print('Failed element JSON: $e');
            print(stack);
          }
        }
      }

      if (kDebugMode) {
        print('Parsed ${assigned.length} assigned + ${unassigned.length} unassigned inspections');
      }

      // Return combined list; ViewModel separates them via getAssigned/getUnassigned
      return [...assigned, ...unassigned];
    } catch (e) {
      if (kDebugMode) {
        print('API request error (getInspectionQueue): $e');
      }
      return [];
    }
  }

  /// Returns only the assigned inspections for this inspector from the queue endpoint
  Future<List<InspectionModel>> getAssignedInspections() async {
    if (kDebugMode) {
      print('API request start: getAssignedInspections');
    }
    try {
      final response = await _apiService.getInspectionQueue();
      if (kDebugMode) {
        print('getAssignedInspections raw response: $response');
      }
      if (response == null) return [];
      final Map<String, dynamic> respMap = response as Map<String, dynamic>;
      final Map<String, dynamic> dataMap = respMap['data'] is Map<String, dynamic>
          ? respMap['data'] as Map<String, dynamic>
          : respMap;
      final List<dynamic> raw = dataMap['assigned'] is List ? dataMap['assigned'] as List : [];
      if (kDebugMode) {
        print('getAssignedInspections: raw assigned length = ${raw.length}');
      }
      
      final List<InspectionModel> list = [];
      for (final e in raw) {
        try {
          list.add(InspectionModel.fromQueueJson(e as Map<String, dynamic>));
        } catch (err, stack) {
          if (kDebugMode) {
            print('Error parsing assigned element in getAssignedInspections: $err');
            print('Element JSON: $e');
            print(stack);
          }
        }
      }
      return list;
    } catch (e) {
      if (kDebugMode) {
        print('getAssignedInspections error: $e');
      }
      return [];
    }
  }

  /// Returns only the unassigned (claimable) inspections from the queue endpoint
  Future<List<InspectionModel>> getUnassignedInspections() async {
    if (kDebugMode) {
      print('API request start: getUnassignedInspections');
    }
    try {
      final response = await _apiService.getInspectionQueue();
      if (kDebugMode) {
        print('getUnassignedInspections raw response: $response');
      }
      if (response == null) return [];
      final Map<String, dynamic> respMap = response as Map<String, dynamic>;
      final Map<String, dynamic> dataMap = respMap['data'] is Map<String, dynamic>
          ? respMap['data'] as Map<String, dynamic>
          : respMap;
      final List<dynamic> raw = dataMap['unassigned'] is List ? dataMap['unassigned'] as List : [];
      if (kDebugMode) {
        print('getUnassignedInspections: raw unassigned length = ${raw.length}');
      }
      
      final List<InspectionModel> list = [];
      for (final e in raw) {
        try {
          list.add(InspectionModel.fromQueueJson(e as Map<String, dynamic>));
        } catch (err, stack) {
          if (kDebugMode) {
            print('Error parsing unassigned element in getUnassignedInspections: $err');
            print('Element JSON: $e');
            print(stack);
          }
        }
      }
      return list;
    } catch (e) {
      if (kDebugMode) {
        print('getUnassignedInspections error: $e');
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
  Future<InspectionModel> claimInspection(String inspectionId) async {
    if (kDebugMode) {
      print('Claim Inspection request start');
      print('Inspection ID being sent: $inspectionId');
    }
    try {
      final response = await _apiService.claimInspection(inspectionId);
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
            print('Parsing success: claimInspection');
          }
          return parsed;
        } catch (e) {
          if (kDebugMode) {
            print('Parsing failure with fromJson, attempting fromQueueJson: $e');
          }
          try {
            final parsed = InspectionModel.fromQueueJson(response['data'] as Map<String, dynamic>);
            return parsed;
          } catch (e2) {
            throw Exception("Parsing failure: $e2");
          }
        }
      } else {
        throw Exception(response['message'] ?? "API returned unsuccessful status");
      }
    } catch (e) {
      if (kDebugMode) {
        print('API request error: $e');
      }
      rethrow;
    }
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
  Future<InspectionModel> completeInspection(String inspectionId, List<Map<String, dynamic>> photos, {String? notes}) async {
    if (kDebugMode) {
      print('Complete Inspection request start');
      print('Inspection ID being sent: $inspectionId');
      print('Photos payload being sent: $photos');
      print('Notes being sent: $notes');
    }
    try {
      final response = await _apiService.completeInspection(inspectionId, {
        'photos': photos,
        if (notes != null) 'notes': notes,
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
    final Map<String, dynamic> payload = {
      'reason': reason,
      'photos': photos,
    };
    if (kDebugMode) {
      print('Fail Inspection request start');
      print('Inspection ID being sent: $inspectionId');
      print('Final JSON Payload: ${jsonEncode(payload)}');
    }
    try {
      final response = await _apiService.failInspection(inspectionId, payload);
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

  bool _isUuid(String str) {
    final regExp = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
    );
    return regExp.hasMatch(str);
  }

  String _normalize(String str) {
    return str.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  }

  @override
  Future<InspectionModel?> getInspectionBySubscription(String subscriptionId) async {
    if (kDebugMode) {
      print('Get Inspection request start');
      print('Subscription ID being sent: $subscriptionId');
    }
    
    final normSearch = _normalize(subscriptionId);
    if (!_isUuid(subscriptionId)) {
      if (kDebugMode) {
        print('Subscription ID "$subscriptionId" is not a UUID. Searching queue for vehicle match...');
      }
      try {
        final queue = await getInspections();
        for (final item in queue) {
          if (_normalize(item.vehicle) == normSearch) {
            if (kDebugMode) {
              print('Found matching inspection in queue for vehicle ${item.vehicle}');
            }
            return item;
          }
        }
        if (kDebugMode) {
          print('No matching inspection found in queue for vehicle "$subscriptionId"');
        }
      } catch (queueErr) {
        if (kDebugMode) {
          print('Error fetching queue for vehicle search: $queueErr');
        }
      }
      return null;
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
        print('API request error: $e. Trying fallback search in queue...');
      }
      try {
        final queue = await getInspections();
        for (final item in queue) {
          if (_normalize(item.vehicle) == normSearch || _normalize(item.id) == normSearch) {
            if (kDebugMode) {
              print('Found fallback match in queue: ${item.vehicle}');
            }
            return item;
          }
        }
      } catch (fallbackErr) {
        if (kDebugMode) {
          print('Error during fallback queue search: $fallbackErr');
        }
      }
      return null;
    }
  }

  @override
  Future<List<InspectionModel>> fetchPendingVerifications() async {
    final all = await getInspections();
    return all.where((e) => e.status == InspectionStatus.pendingVerification).toList();
  }

  @override
  Future<void> approveVerification(String inspectionId, {String? remarks, List<Map<String, dynamic>>? photos}) async {
    if (kDebugMode) {
      print('Approve verification request for $inspectionId');
    }

    // Build photos payload — backend only accepts: url, type, timestamp.
    // lat and lng are NOT accepted and will cause a 400 Validation failed error.
    final formattedPhotos = (photos ?? []).map((p) {
      return {
        'url': p['url'] ?? '',
        'type': 'FRONT',
        'timestamp': p['timestamp'] ?? DateTime.now().toUtc().toIso8601String(),
      };
    }).toList();

    final payload = {
      'photos': formattedPhotos,
      'notes': remarks ?? '',
    };

    final dio = ApiClient().dio;
    final baseUrl = dio.options.baseUrl;
    final claimUrl = '$baseUrl/api/v1/inspections/$inspectionId/claim';

    print('=== CLAIM REQUEST ===');
    print('Inspection ID: $inspectionId');
    print('URL: $claimUrl');

    try {
      final claimResponse = await dio.post(claimUrl);
      print('=== CLAIM RESPONSE ===');
      print('Status Code: ${claimResponse.statusCode}');
      print('Response Body: ${claimResponse.data}');
    } on DioError catch (e) {
      final statusCode = e.response?.statusCode;
      final responseBody = e.response?.data;

      print('=== CLAIM RESPONSE ===');
      print('Status Code: $statusCode');
      print('Response Body: $responseBody');

      final bodyStr = responseBody != null ? responseBody.toString().toLowerCase() : '';
      final isAlreadyClaimed = bodyStr.contains('already claimed') ||
          bodyStr.contains('already assigned') ||
          statusCode == 409 ||
          statusCode == 400;

      if (isAlreadyClaimed) {
        print('Inspection already claimed or assigned. Proceeding to Complete API.');
      } else {
        rethrow;
      }
    } catch (e) {
      print('=== CLAIM RESPONSE ===');
      print('Status Code: Error');
      print('Response Body: $e');
      rethrow;
    }

    final completeUrl = '$baseUrl/api/v1/inspections/$inspectionId/complete';
    print('=== COMPLETE REQUEST ===');
    print('Inspection ID: $inspectionId');
    print('URL: $completeUrl');
    print('=== COMPLETE PAYLOAD ===');
    print(payload.toString());

    try {
      final completeResponse = await dio.post(completeUrl, data: payload);
      print('=== COMPLETE RESPONSE ===');
      print('Status Code: ${completeResponse.statusCode}');
      print('Response Body: ${completeResponse.data}');
    } on DioError catch (e) {
      final statusCode = e.response?.statusCode;
      final responseBody = e.response?.data;

      print('=== COMPLETE RESPONSE ===');
      print('Status Code: $statusCode');
      print('Response Body: $responseBody');
      rethrow;
    } catch (e) {
      print('=== COMPLETE RESPONSE ===');
      print('Status Code: Error');
      print('Response Body: $e');
      rethrow;
    }
  }

  @override
  Future<void> rejectVerification(String inspectionId, String reason, List<String> photoUrls) async {
    if (kDebugMode) {
      print('Reject verification request for $inspectionId with reason $reason');
    }
    await _apiService.failInspection(inspectionId, {
      'reason': reason,
      'photos': photoUrls,
    });
  }

  @override
  Future<void> addComment(String serviceId, String comment) async {
    final payload = {
      'comments': comment,
    };

    if (kDebugMode) {
      print('--- Add Comment API Request ---');
      print('Service ID: $serviceId');
      print('Request Payload: $payload');
      print('-------------------------------');
    }

    try {
      final response = await _apiService.addComment(serviceId, payload);
      
      if (kDebugMode) {
        print('--- Add Comment API Success Response ---');
        print('Service ID: $serviceId');
        print('Response Data: $response');
        print('Status Code: 201');
        print('-----------------------------------------');
      }
    } on DioError catch (dioError) {
      final response = dioError.response;
      if (kDebugMode) {
        print('--- Add Comment API Failure Response ---');
        print('Service ID: $serviceId');
        print('Status Code: ${response?.statusCode}');
        print('Response Data: ${response?.data}');
        print('Error Message: ${dioError.message}');
        print('-----------------------------------------');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('--- Add Comment API Unknown Error ---');
        print('Service ID: $serviceId');
        print('Error: $e');
        print('---------------------------------------');
      }
      rethrow;
    }
  }

}
