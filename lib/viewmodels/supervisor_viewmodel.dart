import 'package:autozy_vendor_app/data/models/alert_model.dart';
import 'package:autozy_vendor_app/data/models/team_member.dart';
import 'package:flutter/foundation.dart';
import '../core/interfaces/supervisor_repository_interface.dart';

enum SupervisorTab { team, alerts }

class SupervisorViewModel extends ChangeNotifier {
  final ISupervisorRepository _repository;

  SupervisorViewModel(this._repository);

  SupervisorTab currentTab = SupervisorTab.team;
  List<TeamMember> members = [];
  List<AlertModel> alerts = [];

  Future<void> loadData() async {
    try {
      // Load data from repository (currently returns same mock data)
      members = await _repository.getTeamMembers();
      alerts = await _repository.getAlerts();
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
          ),
          TeamMember(
            id: "2",
            name: "Sanjay P",
            role: "Detailer",
            tower: "Tower B",
            completed: 8,
            total: 35,
            status: "Active",
          ),
          TeamMember(
            id: "3",
            name: "Deepak S.",
            role: "Inspector",
            tower: "Tower D",
            completed: 3,
            total: 5,
            status: "Active",
          ),
          TeamMember(
            id: "4",
            name: "Anil M",
            role: "Detailer",
            tower: "Tower B",
            completed: 16,
            total: 38,
            status: "Break",
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
