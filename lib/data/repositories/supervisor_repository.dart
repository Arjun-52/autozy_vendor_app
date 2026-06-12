import '../../core/interfaces/supervisor_repository_interface.dart';
import '../../data/models/team_member.dart';
import '../../data/models/alert_model.dart';
import '../../data/models/admin_service_records_response.dart';
import '../../data/models/admin_inspections_response.dart';
import '../services/new_api_service.dart';
import 'package:flutter/foundation.dart';

/// Implementation of SupervisorRepository connecting to NewApiService
class SupervisorRepository implements ISupervisorRepository {
  final NewApiService _apiService;

  SupervisorRepository(this._apiService);
  @override
  Future<List<TeamMember>> getTeamMembers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return existing mock data - EXACTLY SAME as before
    return [
      TeamMember(
        id: "1",
        name: "Raju K.",
        role: "Detailer",
        tower: "Tower A",
        completed: 12,
        total: 40,
        status: "Active",
        phone: "+91 98765 43210",
      ),
      TeamMember(
        id: "2",
        name: "Sanjay P",
        role: "Detailer",
        tower: "Tower B",
        completed: 8,
        total: 35,
        status: "Active",
        phone: "+91 98765 43211",
      ),
      TeamMember(
        id: "3",
        name: "Deepak S.",
        role: "Inspector",
        tower: "Tower D",
        completed: 3,
        total: 5,
        status: "Active",
        phone: "+91 98765 43212",
      ),
      TeamMember(
        id: "4",
        name: "Anil M",
        role: "Detailer",
        tower: "Tower B",
        completed: 16,
        total: 38,
        status: "Break",
        phone: "+91 98765 43213",
      ),
    ];
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
  Future<AdminServiceRecordsResponse> getAdminServiceRecords() async {
    if (kDebugMode) {
      print('Admin Service Records request start');
    }
    try {
      final response = await _apiService.getAdminServiceRecords();
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        throw Exception("Null response received");
      }

      try {
        final parsedResponse = AdminServiceRecordsResponse.fromJson(response as Map<String, dynamic>);
        if (kDebugMode) {
          print('Parsing success');
          print('Pagination data received: total=${parsedResponse.meta.total}, page=${parsedResponse.meta.page}, limit=${parsedResponse.meta.limit}, totalPages=${parsedResponse.meta.totalPages}');
          if (parsedResponse.data.isEmpty) {
            print('Empty records response received');
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
}

