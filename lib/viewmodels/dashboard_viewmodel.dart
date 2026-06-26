import 'dart:io';
import '../../data/models/job_model.dart';
import '../../core/base/base_viewmodel.dart';
import '../../core/interfaces/dashboard_repository_interface.dart';
import 'package:flutter/foundation.dart';

class DashboardViewModel extends BaseViewModel {
  final IDashboardRepository _repository;

  DashboardViewModel(this._repository);

  List<JobModel> _jobs = [];
  bool _isLoggedOut = false;
  Map<String, dynamic> _stats = {
    'completed': 0,
    'total': 0,
    'remaining': 0,
    'cna': 0,
  };

  void undoCNA(int index) {
    if (_isValidIndex(index)) {
      _updateJobStatus(index, JobStatus.pending);
    }
  }

  List<JobModel> get jobs => List.unmodifiable(_jobs);
  bool get isLoggedOut => _isLoggedOut;
  Map<String, dynamic> get stats => _stats;

  Future<void> loadStats() async {
    try {
      _stats = await _repository.getDashboardStats();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load stats: $e');
      }
    }
  }

  Future<void> loadJobs() async {
    await executeOperation(() async {
      final previousCount = _jobs.length;
      _jobs = await _repository.getJobs();
      if (kDebugMode) {
        print(
          'DashboardViewModel replaced jobs list. Previous count: $previousCount, '
          'New count: ${_jobs.length}',
        );
        for (final job in _jobs) {
          print(
            'ViewModel status: ${job.status.logLabel} | Vehicle: ${job.vehicle} '
            '| RecordID: ${job.id}',
          );
        }
      }
      notifyListeners();
      await loadStats();
    }, onError: 'Failed to load jobs');
  }

  Future<bool> markJobCompleted(int index) async {
    if (!_isValidIndex(index)) return false;

    final job = _jobs[index];
    final jobId = _jobRecordId(job);
    
    return await executeOperationWithResult<bool>(() async {
      if (kDebugMode) {
        print(
          'markJobCompleted called with recordId: $jobId | Vehicle: ${job.vehicle} '
          '| Current status: ${job.status.logLabel}',
        );
      }
      final success = await _repository.markJobCompleted(jobId);
      if (success) {
        _updateJobStatus(index, JobStatus.completed);
        await loadStats();
      }
      return success;
    }, onError: 'Failed to complete job') ?? false;
  }

  Future<bool> markCNA(int index) async {
    if (!_isValidIndex(index)) return false;

    final recordId = _jobRecordId(_jobs[index]);
    final success = await _repository.markJobCNA(recordId);

    if (success) {
      _updateJobStatus(index, JobStatus.cna);
    }

    return success;
  }

  Future<bool> undoJob(int index) async {
    if (!_isValidIndex(index)) return false;

    final recordId = _jobRecordId(_jobs[index]);
    final success = await _repository.undoJobStatus(recordId);

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

    final recordId = _jobRecordId(_jobs[index]);
    final success = await _repository.startJobCleaning(recordId);

    if (success) {
      _updateJobStatus(index, JobStatus.cleaning);
    }

    return success;
  }

  void updateBeforePhoto(int index, String url, String timestamp) {
    if (!_isValidIndex(index)) return;
    _jobs[index] = _jobs[index].copyWith(
      beforeImage: url,
      capturedAt: timestamp,
    );
    notifyListeners();
  }

  void updateAfterPhoto(int index, String url, String timestamp) {
    if (!_isValidIndex(index)) return;
    _jobs[index] = _jobs[index].copyWith(
      afterImage: url,
      afterImageCapturedAt: timestamp,
    );
    notifyListeners();
  }

  Future<bool> uploadAfterPhoto(int index, File file) async {
    if (!_isValidIndex(index)) return false;
    final jobId = _jobs[index].id;
    if (jobId == null || jobId.isEmpty) {
      if (kDebugMode) {
        print(
          'uploadAfterPhoto skipped because job id is missing for vehicle: '
          '${_jobs[index].vehicle}',
        );
      }
      return true;
    }

    return await executeOperationWithResult<bool>(() async {
      final result = await _repository.uploadAfterPhoto(jobId, file);
      if (result != null) {
        final photoUrl = result['after_photo_url'] ?? '';
        final uploadedAt = result['after_photo_uploaded_at'] ?? '';

        _jobs[index] = _jobs[index].copyWith(
          afterImage: photoUrl,
          afterImageCapturedAt: uploadedAt,
        );
        if (kDebugMode) {
          print(
            'DashboardViewModel uploadAfterPhoto updated job ${_jobs[index].vehicle} '
            'with after_photo_url: $photoUrl',
          );
        }
        notifyListeners();
        return true;
      }
      return false;
    }, onError: 'Upload failed') ?? false;
  }

  Future<JobRemarkModel?> addJobRemark(int index, String? reason, String? additionalComment) async {
    if (!_isValidIndex(index)) return null;

    final recordId = _jobRecordId(_jobs[index]);
    await _repository.saveJobRemark(recordId, reason, additionalComment);

    final remark = JobRemarkModel(
      reason: reason,
      additionalComment: additionalComment,
      createdBy: 'Detailer Mode',
      userRole: 'Detailer',
      createdAt: DateTime.now().toLocal().toString().split('.')[0],
    );

    final list = List<JobRemarkModel>.from(_jobs[index].remarks ?? []);
    list.insert(0, remark);
    _jobs[index] = _jobs[index].copyWith(
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

        _jobs[index] = _jobs[index].copyWith(
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
    final recordId = _jobRecordId(_jobs[index]);
    final success = await _repository.markJobCNA(recordId);

    if (success) {
      _updateJobStatus(index, JobStatus.cna);
    }

    return success;
  }

  // Helper methods
  bool _isValidIndex(int index) {
    return index >= 0 && index < _jobs.length;
  }

  String _jobRecordId(JobModel job) {
    final id = job.id;
    if (id != null && id.isNotEmpty) {
      return id;
    }
    return job.vehicle;
  }

  void _updateJobStatus(int index, JobStatus status) {
    _jobs[index] = _jobs[index].copyWith(
      status: status,
    );
    if (kDebugMode) {
      print(
        'DashboardViewModel local status updated: ${_jobs[index].status.logLabel} '
        '| Vehicle: ${_jobs[index].vehicle} | RecordID: ${_jobs[index].id}',
      );
    }
    notifyListeners();
  }

  void resetRole() {
    _isLoggedOut = false;
    notifyListeners();
  }
}
