import '../../data/models/assigned_job_model.dart';
import '../../data/models/specialist_kpi_response.dart';

abstract class ISpecialistRepository {
  Future<List<AssignedJobModel>> fetchAssignedJobs();
  Future<SpecialistKpiData> fetchKpis();
}
