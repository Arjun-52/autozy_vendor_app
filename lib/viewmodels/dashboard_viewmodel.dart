import '../../data/models/job_model.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../core/base/base_viewmodel.dart';

class DashboardViewModel extends BaseViewModel {
  final DashboardRepository _repository;

  DashboardViewModel(this._repository);

  List<JobModel> _jobs = [];
  bool _isLoggedOut = false;

  void undoCNA(int index) {
    if (_isValidIndex(index)) {
      _updateJobStatus(index, JobStatus.pending);
    }
  }

  List<JobModel> get jobs => List.unmodifiable(_jobs);
  bool get isLoggedOut => _isLoggedOut;

  Future<void> loadJobs() async {
    await executeOperation(() async {
      _jobs = await _repository.getJobs();
    }, onError: 'Failed to load jobs');
  }

  Future<bool> markJobCompleted(int index) async {
    if (!_isValidIndex(index)) return false;

    final vehicleId = _jobs[index].vehicle;
    final success = await _repository.markJobCompleted(vehicleId);

    if (success) {
      _updateJobStatus(index, JobStatus.completed);
    }

    return success;
  }

  Future<bool> markCNA(int index) async {
    if (!_isValidIndex(index)) return false;

    final vehicleId = _jobs[index].vehicle;
    final success = await _repository.markJobCNA(vehicleId);

    if (success) {
      _updateJobStatus(index, JobStatus.cna);
    }

    return success;
  }

  Future<bool> undoJob(int index) async {
    if (!_isValidIndex(index)) return false;

    final vehicleId = _jobs[index].vehicle;
    final success = await _repository.undoJobStatus(vehicleId);

    if (success) {
      _updateJobStatus(index, JobStatus.pending);
    }

    return success;
  }

  JobModel? getJob(int index) {
    return _isValidIndex(index) ? _jobs[index] : null;
  }

  // Helper methods
  bool _isValidIndex(int index) {
    return index >= 0 && index < _jobs.length;
  }

  void _updateJobStatus(int index, JobStatus status) {
    _jobs[index] = JobModel(
      vehicle: _jobs[index].vehicle,
      name: _jobs[index].name,
      location: _jobs[index].location,
      phone: _jobs[index].phone,
      status: status,
    );
    notifyListeners();
  }

  void resetRole() {
    _isLoggedOut = false;
    notifyListeners();
  }
}
