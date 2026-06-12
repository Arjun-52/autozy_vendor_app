import 'package:autozy_vendor_app/data/models/alert_model.dart';
import 'package:autozy_vendor_app/data/models/team_member.dart';
import 'package:autozy_vendor_app/data/models/admin_service_records_response.dart';
import 'package:autozy_vendor_app/data/models/admin_inspections_response.dart';
import 'package:flutter/foundation.dart';
import '../core/interfaces/supervisor_repository_interface.dart';

enum SupervisorTab { team, alerts, records }

class SupervisorViewModel extends ChangeNotifier {
  final ISupervisorRepository _repository;

  SupervisorViewModel(this._repository);

  SupervisorTab currentTab = SupervisorTab.team;
  List<TeamMember> members = [];
  List<AlertModel> alerts = [];

  bool isLoadingServiceRecords = false;
  String? serviceRecordsError;
  AdminServiceRecordsResponse? serviceRecordsResponse;
  List<dynamic> serviceRecords = [];

  Future<void> fetchServiceRecords() async {
    if (kDebugMode) {
      print('Controller fetch start');
    }
    isLoadingServiceRecords = true;
    serviceRecordsError = null;
    notifyListeners();

    try {
      final response = await _repository.getAdminServiceRecords();
      serviceRecordsResponse = response;
      serviceRecords = response.data;
      if (kDebugMode) {
        print('Controller fetch success');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Controller fetch failure: $e');
      }
      serviceRecordsError = e.toString();
    } finally {
      isLoadingServiceRecords = false;
      notifyListeners();
    }
  }

  bool isLoadingInspections = false;
  String? inspectionsError;
  AdminInspectionsResponse? inspectionsResponse;
  List<AdminInspectionRecord> inspections = [];

  Future<void> fetchInspections() async {
    if (kDebugMode) {
      print('Controller fetch start');
    }
    isLoadingInspections = true;
    inspectionsError = null;
    notifyListeners();

    try {
      final response = await _repository.getAdminInspections();
      inspectionsResponse = response;
      inspections = response.data;
      if (kDebugMode) {
        print('Controller fetch success');
      }

      // Process inspections to populate inspector team members
      final Map<String, List<AdminInspectionRecord>> inspectorGroup = {};
      for (var record in inspections) {
        if (record.inspector != null) {
          final inspectorId = record.inspector!.id;
          inspectorGroup.putIfAbsent(inspectorId, () => []).add(record);
        }
      }

      // Filter members to keep only non-inspectors, then append new inspector members
      members.removeWhere((m) => m.role.trim().toLowerCase() == 'inspector');

      inspectorGroup.forEach((inspectorId, records) {
        final firstRecord = records.first;
        final inspector = firstRecord.inspector!;

        members.add(
          TeamMember(
            id: inspector.id,
            name: inspector.name,
            role: inspector.role, // "Inspector"
            tower: "Tower A", // Default
            completed: 0,
            total: 0,
            status: "Active", // Default
            phone: "+91 98765 43210", // Default
          ),
        );
      });

      // Process inspections to populate alert cards
      final List<AlertModel> inspectionAlerts = [];
      
      // Sort inspections first (latest completed_at or scheduled_at)
      final sortedInspections = List<AdminInspectionRecord>.from(inspections);
      sortedInspections.sort((a, b) {
        final aTime = DateTime.tryParse(a.completedAt ?? a.scheduledAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = DateTime.tryParse(b.completedAt ?? b.scheduledAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime); // Latest first
      });

      // Prioritize displaying REJECTED inspections in Alerts
      final rejected = sortedInspections.where((r) => r.status.toUpperCase() == 'REJECTED').toList();
      final others = sortedInspections.where((r) => r.status.toUpperCase() != 'REJECTED').toList();
      final prioritizedInspections = [...rejected, ...others];

      for (var record in prioritizedInspections) {
        final vehicleNum = record.vehicle?.vehicleNumber ?? '';
        final timeStr = _getRelativeTime(record.completedAt ?? record.scheduledAt);

        // 1. Rejected Inspection
        if (record.status.toUpperCase() == 'REJECTED') {
          inspectionAlerts.add(
            AlertModel(
              title: "Inspection Rejected\nVehicle $vehicleNum could not be inspected\nReason: ${record.notes ?? 'Vehicle was locked and inspection could not be performed'}",
              time: timeStr,
              type: "fraud",
            ),
          );
        }

        // 2. Parking Access Issue
        if (record.parkingAvailable == false) {
          inspectionAlerts.add(
            AlertModel(
              title: "Parking unavailable for vehicle $vehicleNum",
              time: timeStr,
              type: "idle",
            ),
          );
        }

        // 3. Keys Not Provided
        if (record.keysProvided == false) {
          inspectionAlerts.add(
            AlertModel(
              title: "Keys not provided for inspection",
              time: timeStr,
              type: "idle",
            ),
          );
        }

        // 4. Security Permission Missing
        if (record.securityPermission == false) {
          inspectionAlerts.add(
            AlertModel(
              title: "Security permission pending for inspection",
              time: timeStr,
              type: "idle",
            ),
          );
        }
      }

      // Merge mock alerts and inspection alerts
      final mockAlerts = alerts.where((a) => 
        !a.title.startsWith("Inspection Rejected") &&
        !a.title.startsWith("Parking unavailable") &&
        !a.title.startsWith("Keys not provided") &&
        !a.title.startsWith("Security permission")
      ).toList();

      alerts = [...inspectionAlerts, ...mockAlerts];

    } catch (e) {
      if (kDebugMode) {
        print('Controller fetch failure: $e');
      }
      inspectionsError = e.toString();
    } finally {
      isLoadingInspections = false;
      notifyListeners();
    }
  }

  String _getRelativeTime(String? dateStr) {
    if (dateStr == null) return "Today";
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) {
        return "just now";
      } else if (difference.inMinutes < 60) {
        final mins = difference.inMinutes;
        return "$mins min${mins > 1 ? 's' : ''} ago";
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return "$hours hour${hours > 1 ? 's' : ''} ago";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} days ago";
      } else {
        return "Today";
      }
    } catch (e) {
      return "Today";
    }
  }

  Future<void> loadData() async {
    try {
      // Load data from repository (currently returns same mock data)
      members = await _repository.getTeamMembers();
      alerts = await _repository.getAlerts();
      await fetchServiceRecords();
      await fetchInspections();
      notifyListeners();
    } catch (e) {
      // Keep existing mock data as fallback
      if (members.isEmpty) {
        members = [
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

      if (alerts.isEmpty) {
        alerts = [
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
      notifyListeners();
    }
  }

  int get activeCount => members.where((e) => e.status == "Active").length;

  int get breakCount => members.where((e) => e.status == "Break").length;

  int get offlineCount => members.where((e) => e.status == "Offline").length;

  Future<void> updateMemberStatus(String memberName, String newStatus) async {
    final index = members.indexWhere((m) => m.name == memberName);
    if (index != -1) {
      // Use repository for API call
      final success = await _repository.updateMemberStatus(
        members[index].id,
        newStatus,
      );

      if (success) {
        final member = members[index];
        members[index] = TeamMember(
          id: member.id,
          name: member.name,
          role: member.role,
          tower: member.tower,
          completed: member.completed,
          total: member.total,
          status: newStatus,
          phone: member.phone,
        );
        notifyListeners();
      }
    }
  }

  void switchTab(SupervisorTab tab) {
    currentTab = tab;
    notifyListeners();
  }

  Future<void> addMember(TeamMember member) async {
    final success = await _repository.addTeamMember(member);
    if (success) {
      members.add(member);
      notifyListeners();
    }
  }

  Future<void> removeMember(String memberName) async {
    final index = members.indexWhere((m) => m.name == memberName);
    if (index != -1) {
      final success = await _repository.removeTeamMember(members[index].id);
      if (success) {
        members.removeWhere((m) => m.name == memberName);
        notifyListeners();
      }
    }
  }
}
