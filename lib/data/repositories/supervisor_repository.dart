import '../../core/interfaces/supervisor_repository_interface.dart';
import '../../data/models/team_member.dart';
import '../../data/models/alert_model.dart';

/// Mock implementation of SupervisorRepository
/// Returns existing mock data to maintain backward compatibility
class SupervisorRepository implements ISupervisorRepository {
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
}
