import 'package:autozy_vendor_app/data/models/alert_model.dart';
import 'package:autozy_vendor_app/data/models/team_member.dart';
import 'package:autozy_vendor_app/data/models/admin_service_records_response.dart';
import 'package:autozy_vendor_app/data/models/admin_inspections_response.dart';
import 'package:autozy_vendor_app/data/models/notification_model.dart';
import 'package:autozy_vendor_app/data/models/pagination_meta.dart';
import 'package:flutter/foundation.dart';
import '../core/interfaces/supervisor_repository_interface.dart';
import '../data/models/attendance_model.dart';
import '../data/models/attendance_response.dart';
enum SupervisorTab { team, alerts, records }

class SupervisorViewModel extends ChangeNotifier {
  final ISupervisorRepository _repository;

  SupervisorViewModel(this._repository);

  SupervisorTab currentTab = SupervisorTab.team;
  List<TeamMember> members = [];
  List<AlertModel> alerts = [];

  bool isLoadingNotifications = false;
  String? notificationsError;
  List<NotificationModel> notifications = [];
  PaginationMeta? notificationsMeta;

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
bool isLoadingAttendance = false;
String? attendanceError;
AttendanceResponse? attendanceResponse;
List<AttendanceModel> attendanceRecords = [];
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
    role: inspector.role,
    phone: '',
    areaId: '',
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
Future<void> fetchAttendance() async {
  if (kDebugMode) {
    print('Attendance fetch start');
  }

  isLoadingAttendance = true;
  attendanceError = null;
  notifyListeners();

  try {
    final response = await _repository.getAdminAttendance();

    attendanceResponse = response;
    attendanceRecords = response.items;

    // Map attendance records to team members
    for (int i = 0; i < members.length; i++) {
      final member = members[i];
      final attendance = attendanceRecords.firstWhere(
        (a) => a.staffId == member.id,
        orElse: () => AttendanceModel(id: '', staffId: '', date: ''),
      );

      String memberStatus = 'Offline';
      if (attendance.id.isNotEmpty) {
        if (attendance.checkIn != null && attendance.checkOut == null) {
          memberStatus = attendance.status?.toUpperCase() == 'BREAK' ? 'On Break' : 'Active';
        } else if (attendance.checkOut != null) {
          memberStatus = 'Offline';
        } else if (attendance.status?.toUpperCase() == 'PRESENT' || attendance.status?.toUpperCase() == 'ACTIVE') {
          memberStatus = 'Active';
        }
      }

      members[i] = TeamMember(
        id: member.id,
        name: member.name,
        phone: member.phone,
        role: member.role,
        areaId: member.areaId,
        tower: member.tower,
        completed: member.completed,
        total: member.total,
        status: memberStatus,
      );
    }

    if (kDebugMode) {
      print('Attendance fetch success');
      print('Attendance records: ${attendanceRecords.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Attendance fetch failure: $e');
    }
    attendanceError = e.toString();
  } finally {
    isLoadingAttendance = false;
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
    if (kDebugMode) {
      print(e);
    }
    return "Today";
  }
}
Future<void> loadData() async {
  try {
    members = await _repository.getTeamMembers();
    alerts = await _repository.getAlerts();
    await fetchAttendance();
    await fetchServiceRecords();
    await fetchInspections();
    await fetchNotifications(refresh: true);

    notifyListeners();
  } catch (e) {
    if (kDebugMode) {
      print("LoadData Error: $e");
    }
    notifyListeners();
  }
}
  int get activeCount => members.where((m) => m.status == 'Active').length;

  int get breakCount => members.where((m) => m.status == 'On Break').length;

  int get offlineCount => members.where((m) => m.status == 'Offline').length;

  int get unreadNotificationsCount => notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      notifications.clear();
      notificationsMeta = null;
    }

    final nextPage = (notificationsMeta?.page ?? 0) + 1;
    final totalPages = notificationsMeta?.totalPages ?? 1;

    if (!refresh && nextPage > totalPages) return;

    isLoadingNotifications = true;
    notificationsError = null;
    notifyListeners();

    try {
      final response = await _repository.getNotifications(page: nextPage, limit: 20);
      if (refresh) {
        notifications = response.data;
      } else {
        notifications.addAll(response.data);
      }
      notificationsMeta = response.meta;
    } catch (e) {
      notificationsError = e.toString();
    } finally {
      isLoadingNotifications = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    final success = await _repository.markNotificationAsRead(id);
    if (success) {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final current = notifications[index];
        notifications[index] = NotificationModel(
          id: current.id,
          userId: current.userId,
          staffId: current.staffId,
          type: current.type,
          title: current.title,
          body: current.body,
          data: current.data,
          isRead: true,
          createdAt: current.createdAt,
        );
        notifyListeners();
      }
    }
  }

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
  phone: member.phone,
  areaId: member.areaId,
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
