import '../../data/models/task_model.dart';
import '../../data/models/addon_service.dart';
import '../../data/models/my_addon_bookings_response.dart';
import '../../data/models/specialist_job_model.dart';
import '../../data/models/staff_issue_model.dart';

abstract class ISpecialistTasksRepository {
  Future<List<Task>> getTasks();
  Future<bool> startTask(int taskIndex);
  Future<bool> completeTask(int taskIndex);
  Future<bool> toggleStep(int taskIndex, int stepIndex);
  Future<List<SpecialistJobModel>> getSpecialistJobs({required String date});
  Future<List<AddOnService>> getAddonServices();
  Future<MyAddonBookingsResponse> getMyAddonBookings({
    required int page,
    required int limit,
  });
  Future<bool> acceptSpecialistJob(String id);
  Future<bool> startSpecialistJob(String id, List<Map<String, dynamic>> beforePhotos);
  Future<bool> uploadSpecialistBeforePhotos(String id, List<String> photos);
  Future<bool> uploadSpecialistAfterPhotos(String id, List<String> photos);
  Future<bool> completeSpecialistJob(String id, List<Map<String, dynamic>> afterPhotos, String notes);
  Future<bool> cancelSpecialistJob(String id, String reason);
  Future<StaffIssueResponse?> reportStaffIssue(StaffIssueRequest request);
}
