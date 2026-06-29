import '../../core/interfaces/supervisor_repository_interface.dart';
import '../../data/models/team_member.dart';
import '../../data/models/alert_model.dart';
import '../../data/models/admin_service_records_response.dart';
import '../../data/models/admin_inspections_response.dart';
import '../services/new_api_service.dart';
import 'package:flutter/foundation.dart';
import '../models/attendance_model.dart';
import '../models/attendance_response.dart';
import '../models/notification_response.dart';
/// Implementation of SupervisorRepository connecting to NewApiService
class SupervisorRepository implements ISupervisorRepository {
  final NewApiService _apiService;

  SupervisorRepository(this._apiService);

@override
Future<List<TeamMember>> getTeamMembers() async {
  if (kDebugMode) {
    print('==============================');
    print('Calling GET /api/v1/workforce/staff');
    print('Role: DETAILER');
    print('==============================');
  }

  try {
    final response = await _apiService.getTeamMembers("DETAILER");

    if (kDebugMode) {
      print('Raw API Response:');
      print(response);
    }

    final items = response['data'] as List<dynamic>;

    final members = items
        .map((item) => TeamMember.fromJson(item as Map<String, dynamic>))
        .toList();

    if (kDebugMode) {
      print('Total Team Members: ${members.length}');
    }

    return members;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error fetching Team Members:');
      print(e);
      print(stackTrace);
    }
    rethrow;
  }
}

  @override
  Future<List<AlertModel>> getAlerts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Return existing mock data - EXACTLY SAME as before
    return [
      AlertModel(
        title: "Raju K. has been idle for 25 mins",
        time: "10 min ago",
        type: "idle",
      ),
      AlertModel(
        title: "Fraud flag raised on MH 01 KL 1111",
        time: "16 min ago",
        type: "fraud",
      ),
      AlertModel(
        title: "Sanjay P. completed Tower B route",
        time: "30 min ago",
        type: "success",
      ),
    ];
  }

  @override
  Future<bool> updateMemberStatus(String memberId, String status) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // Always succeed for now
  }

  @override
  Future<bool> addTeamMember(TeamMember member) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Always succeed for now
  }

  @override
  Future<bool> removeTeamMember(String memberId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // Always succeed for now
  }

  @override
  @override
Future<AdminServiceRecordsResponse> getAdminServiceRecords() async {
  if (kDebugMode) {
    print('Admin Service Records request start');
  }

  try {
    final today = DateTime.now().toIso8601String().split('T').first;

    if (kDebugMode) {
      print('Fetching Admin Service Records for: $today');
    }

    final response = await _apiService.getAdminServiceRecords(today);

    if (kDebugMode) {
      print('Admin Service Records Response: $response');
    }

    if (response == null) {
      throw Exception("Null response received");
    }

    final parsedResponse =
        AdminServiceRecordsResponse.fromJson(response as Map<String, dynamic>);

    if (kDebugMode) {
      print('Parsing success');
      print(
        'Pagination: total=${parsedResponse.meta.total}, page=${parsedResponse.meta.page}',
      );
    }

    return parsedResponse;
  } catch (e) {
    if (kDebugMode) {
      print('Admin Service Records Error: $e');
    }
    rethrow;
  }
}
@override
Future<AttendanceResponse> getAdminAttendance() async {
  if (kDebugMode) {
    print('Admin Attendance request start');
  }

  try {
    final today = DateTime.now().toIso8601String().split('T').first;

    if (kDebugMode) {
      print('Fetching Attendance for: $today');
    }

    final response = await _apiService.getAdminAttendance(today);

    if (kDebugMode) {
      print('Attendance Response: $response');
    }

    if (response == null) {
      throw Exception("Null response received");
    }

    final parsedResponse =
        AttendanceResponse.fromJson(response as Map<String, dynamic>);

    if (kDebugMode) {
      print(
          'Attendance Parsing Success. Records: ${parsedResponse.items.length}');
    }

    return parsedResponse;
  } catch (e) {
    if (kDebugMode) {
      print('Attendance Error: $e');
    }
    rethrow;
  }
}
  @override
  Future<AdminInspectionsResponse> getAdminInspections() async {
    if (kDebugMode) {
      print('Admin Inspections request start');
    }
    try {
      final response = await _apiService.getAdminInspections();
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        throw Exception("Null response received");
      }

      try {
        final parsedResponse = AdminInspectionsResponse.fromJson(response as Map<String, dynamic>);
        if (kDebugMode) {
          print('Parsing success');
          print('Pagination data received: total=${parsedResponse.meta.total}, page=${parsedResponse.meta.page}, limit=${parsedResponse.meta.limit}, totalPages=${parsedResponse.meta.totalPages}');
          if (parsedResponse.data.isEmpty) {
            print('Empty inspections response received');
          }
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
  Future<NotificationResponse> getNotifications({required int page, required int limit}) async {
    if (kDebugMode) {
      print('SupervisorRepository: getNotifications request start (page: $page, limit: $limit)');
    }
    try {
      final response = await _apiService.getNotifications(page, limit);
      if (kDebugMode) {
        print('SupervisorRepository: getNotifications response received: $response');
      }
      if (response == null) {
        throw Exception("Null response received");
      }
      return NotificationResponse.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print('SupervisorRepository: getNotifications error: $e');
      }
      rethrow;
    }
  }

  @override
  Future<bool> markNotificationAsRead(String id) async {
    if (kDebugMode) {
      print('SupervisorRepository: markNotificationAsRead request start (id: $id)');
    }
    try {
      await _apiService.markNotificationAsRead(id);
      if (kDebugMode) {
        print('SupervisorRepository: markNotificationAsRead success');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('SupervisorRepository: markNotificationAsRead error: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> reassignServiceRecord(String serviceRecordUuid, String detailerId) async {
    if (kDebugMode) {
      print('SupervisorRepository: reassignServiceRecord start (uuid: $serviceRecordUuid, detailerId: $detailerId)');
    }
    try {
      final response = await _apiService.reassignDetailer(
        serviceRecordUuid,
        {'detailer_id': detailerId},
      );
      if (kDebugMode) {
        print('SupervisorRepository: reassignServiceRecord response: $response');
      }
      return response != null && response['success'] == true;
    } catch (e) {
      if (kDebugMode) {
        print('SupervisorRepository: reassignServiceRecord error: $e');
      }
      return false;
    }
  }
}

