import 'package:flutter/foundation.dart';

import '../core/interfaces/specialist_repository_interface.dart';
import '../data/models/assigned_job_model.dart';

class SpecialistViewModel extends ChangeNotifier {
  final ISpecialistRepository _repository;

  SpecialistViewModel(this._repository);

  List<AssignedJobModel> assignedJobs = [];
  bool isLoading = false;
  String? errorMessage;

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
}
