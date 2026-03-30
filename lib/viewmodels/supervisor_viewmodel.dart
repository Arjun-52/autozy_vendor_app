import 'package:autozy_vendor_app/data/models/team_member.dart';
import 'package:flutter/foundation.dart';

class SupervisorViewModel extends ChangeNotifier {
  List<TeamMember> members = [
    TeamMember(
      name: "Raju K.",
      role: "Detailer",
      tower: "Tower A",
      completed: 12,
      total: 40,
      status: "Active",
    ),
    TeamMember(
      name: "Sanjay P",
      role: "Detailer",
      tower: "Tower B",
      completed: 8,
      total: 35,
      status: "Active",
    ),
    TeamMember(
      name: "Deepak S.",
      role: "Inspector",
      tower: "Tower D",
      completed: 3,
      total: 5,
      status: "Active",
    ),
    TeamMember(
      name: "Anil M",
      role: "Detailer",
      tower: "Tower B",
      completed: 16,
      total: 38,
      status: "Break",
    ),
  ];

  int get activeCount => members.where((e) => e.status == "Active").length;

  int get breakCount => members.where((e) => e.status == "Break").length;

  int get offlineCount => members.where((e) => e.status == "Offline").length;

  void updateMemberStatus(String memberName, String newStatus) {
    final index = members.indexWhere((m) => m.name == memberName);
    if (index != -1) {
      final member = members[index];
      members[index] = TeamMember(
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

  void addMember(TeamMember member) {
    members.add(member);
    notifyListeners();
  }

  void removeMember(String memberName) {
    members.removeWhere((m) => m.name == memberName);
    notifyListeners();
  }
}
