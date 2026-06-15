import '../../data/models/job_model.dart';
import '../../core/base/base_viewmodel.dart';
import '../../core/interfaces/dashboard_repository_interface.dart';

class DashboardViewModel extends BaseViewModel {
  final IDashboardRepository _repository;

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

  Future<bool> startJobCleaning(int index) async {
    if (!_isValidIndex(index)) return false;

    final vehicleId = _jobs[index].vehicle;
    final success = await _repository.startJobCleaning(vehicleId);

    if (success) {
      _updateJobStatus(index, JobStatus.cleaning);
    }

    return success;
  }

  void updateBeforePhoto(int index, String url, String timestamp) {
    if (!_isValidIndex(index)) return;
    _jobs[index] = JobModel(
      vehicle: _jobs[index].vehicle,
      name: _jobs[index].name,
      location: _jobs[index].location,
      phone: _jobs[index].phone,
      status: _jobs[index].status,
      beforeImage: url,
      capturedAt: timestamp,
      afterImage: _jobs[index].afterImage,
      afterImageCapturedAt: _jobs[index].afterImageCapturedAt,
      remarks: _jobs[index].remarks,
    );
    notifyListeners();
  }

  void updateAfterPhoto(int index, String url, String timestamp) {
    if (!_isValidIndex(index)) return;
    _jobs[index] = JobModel(
      vehicle: _jobs[index].vehicle,
      name: _jobs[index].name,
      location: _jobs[index].location,
      phone: _jobs[index].phone,
      status: _jobs[index].status,
      beforeImage: _jobs[index].beforeImage,
      capturedAt: _jobs[index].capturedAt,
      afterImage: url,
      afterImageCapturedAt: timestamp,
      remarks: _jobs[index].remarks,
    );
    notifyListeners();
  }

  Future<JobRemarkModel?> addJobRemark(int index, String? reason, String? additionalComment) async {
    if (!_isValidIndex(index)) return null;

    final vehicleId = _jobs[index].vehicle;
    await _repository.saveJobRemark(vehicleId, reason, additionalComment);

    final remark = JobRemarkModel(
      reason: reason,
      additionalComment: additionalComment,
      createdBy: 'Detailer Mode',
      userRole: 'Detailer',
      createdAt: DateTime.now().toLocal().toString().split('.')[0],
    );

    final list = List<JobRemarkModel>.from(_jobs[index].remarks ?? []);
    list.insert(0, remark);
    _jobs[index] = JobModel(
      vehicle: _jobs[index].vehicle,
      name: _jobs[index].name,
      location: _jobs[index].location,
      phone: _jobs[index].phone,
      status: _jobs[index].status,
      beforeImage: _jobs[index].beforeImage,
      capturedAt: _jobs[index].capturedAt,
      afterImage: _jobs[index].afterImage,
      afterImageCapturedAt: _jobs[index].afterImageCapturedAt,
      remarks: list,
    );
    notifyListeners();
    return remark;
  }

  Future<bool> updateJobRemark(int index, String remarkId, String? reason, String? additionalComment) async {
    if (!_isValidIndex(index)) return false;

    final success = await _repository.updateJobRemark(remarkId, reason, additionalComment);

    if (success) {
      final list = List<JobRemarkModel>.from(_jobs[index].remarks ?? []);
      final remarkIdx = list.indexWhere((r) => r.id == remarkId);
      if (remarkIdx != -1) {
        final oldRemark = list[remarkIdx];
        list[remarkIdx] = JobRemarkModel(
          id: oldRemark.id,
          jobId: oldRemark.jobId,
          reason: reason,
          additionalComment: additionalComment,
          createdBy: oldRemark.createdBy,
          userRole: oldRemark.userRole,
          userId: oldRemark.userId,
          createdAt: DateTime.now().toLocal().toString().split('.')[0],
        );

        _jobs[index] = JobModel(
          vehicle: _jobs[index].vehicle,
          name: _jobs[index].name,
          location: _jobs[index].location,
          phone: _jobs[index].phone,
          status: _jobs[index].status,
          beforeImage: _jobs[index].beforeImage,
          capturedAt: _jobs[index].capturedAt,
          afterImage: _jobs[index].afterImage,
          afterImageCapturedAt: _jobs[index].afterImageCapturedAt,
          remarks: list,
        );
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> markJobCNAWithRemark(int index, String reason, String? additionalComment) async {
    if (!_isValidIndex(index)) return false;
    
    // Save remark first
    await addJobRemark(index, reason, additionalComment);
    
    // Mark as CNA
    final vehicleId = _jobs[index].vehicle;
    final success = await _repository.markJobCNA(vehicleId);

    if (success) {
      _updateJobStatus(index, JobStatus.cna);
    }

    return success;
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
      beforeImage: _jobs[index].beforeImage,
      capturedAt: _jobs[index].capturedAt,
      afterImage: _jobs[index].afterImage,
      afterImageCapturedAt: _jobs[index].afterImageCapturedAt,
      remarks: _jobs[index].remarks,
    );
    notifyListeners();
  }

  void resetRole() {
    _isLoggedOut = false;
    notifyListeners();
  }
}
