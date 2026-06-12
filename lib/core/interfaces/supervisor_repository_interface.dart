import '../../data/models/team_member.dart';
import '../../data/models/alert_model.dart';
import '../../data/models/admin_service_records_response.dart';
import '../../data/models/admin_inspections_response.dart';

/// Repository interface for Supervisor operations
/// Enables loose coupling and easy API integration
abstract class ISupervisorRepository {
  /// Get all team members
  Future<List<TeamMember>> getTeamMembers();

  /// Get all alerts
  Future<List<AlertModel>> getAlerts();

  /// Update team member status
  Future<bool> updateMemberStatus(String memberId, String status);

  /// Add new team member
  Future<bool> addTeamMember(TeamMember member);

  /// Remove team member
  Future<bool> removeTeamMember(String memberId);

  /// Get admin service records
  Future<AdminServiceRecordsResponse> getAdminServiceRecords();

  /// Get admin inspections
  Future<AdminInspectionsResponse> getAdminInspections();
}
