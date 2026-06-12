import '../../data/models/task_model.dart';
import '../../data/models/addon_service.dart';
import '../../data/models/my_addon_bookings_response.dart';

import '../../data/models/specialist_job_model.dart';

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
}
