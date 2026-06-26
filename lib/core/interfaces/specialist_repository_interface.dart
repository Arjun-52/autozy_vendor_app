import '../../data/models/assigned_job_model.dart';

abstract class ISpecialistRepository {
  Future<List<AssignedJobModel>> fetchAssignedJobs();
}
