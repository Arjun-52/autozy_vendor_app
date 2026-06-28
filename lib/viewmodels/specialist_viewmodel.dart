import 'package:flutter/foundation.dart';

import '../core/interfaces/specialist_repository_interface.dart';
import '../data/models/assigned_job_model.dart';
import '../data/models/specialist_kpi_response.dart';

class SpecialistViewModel extends ChangeNotifier {
  final ISpecialistRepository _repository;

  SpecialistViewModel(this._repository);

  List<AssignedJobModel> assignedJobs = [];
  bool isLoading = false;
  String? errorMessage;

  SpecialistKpiData? kpis;
  bool isLoadingKpis = false;
  String? kpisErrorMessage;

  Future<void> loadDashboardData() async {
    await Future.wait([
      loadAssignedJobs(),
      loadKpis(),
    ]);
  }

  Future<void> loadAssignedJobs() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      assignedJobs = await _repository.fetchAssignedJobs();
      errorMessage = null;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadKpis() async {
    isLoadingKpis = true;
    kpisErrorMessage = null;
    notifyListeners();

    try {
      kpis = await _repository.fetchKpis();
      kpisErrorMessage = null;
    } catch (error) {
      kpisErrorMessage = error.toString();
    } finally {
      isLoadingKpis = false;
      notifyListeners();
    }
  }
}
