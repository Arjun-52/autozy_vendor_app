import 'package:flutter/foundation.dart';
import '../core/base/base_viewmodel.dart';
import '../core/interfaces/inspector_repository_interface.dart';
import '../data/models/inspection_model.dart';

class InspectorViewModel extends BaseViewModel {
  final IInspectorRepository _repository;

  InspectorViewModel(this._repository);

  List<InspectionModel> _inspections = [];

  List<InspectionModel> get inspections => _inspections;

  InspectionModel? _currentSubscriptionInspection;
  InspectionModel? get currentSubscriptionInspection => _currentSubscriptionInspection;

  Future<void> fetchInspectionBySubscription(String subscriptionId) async {
    if (kDebugMode) {
      print('Controller fetch start: fetchInspectionBySubscription');
    }
    await executeOperation(
      () async {
        _currentSubscriptionInspection = await _repository.getInspectionBySubscription(subscriptionId);
      },
      onError: "Failed to fetch inspection by subscription",
      onSuccess: () {
        if (kDebugMode) {
          print('Controller fetch success: fetchInspectionBySubscription');
        }
      },
    );
    if (errorMessage != null) {
      if (kDebugMode) {
        print('Controller fetch failure: $errorMessage');
      }
    }
  }

  Future<void> loadInspections() async {
    if (kDebugMode) {
      print('Controller fetch start: loadInspections');
    }
    await executeOperation(
      () async {
        _inspections = await _repository.getInspections();
      },
      onError: "Failed to load inspections",
      onSuccess: () {
        if (kDebugMode) {
          print('Controller fetch success: loaded ${_inspections.length} inspections');
        }
      },
    );
    if (errorMessage != null) {
      if (kDebugMode) {
        print('Controller fetch failure: $errorMessage');
      }
    }
  }

  void approveInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.approveInspection(_inspections[index].vehicle).then((_) {
      _inspections[index].status = InspectionStatus.approved;
      notifyListeners();
    });
  }

  void flagInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.flagInspection(_inspections[index].vehicle).then((_) {
      _inspections[index].status = InspectionStatus.flagged;
      notifyListeners();
    });
  }

  void addPhoto(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.addPhoto(_inspections[index].vehicle).then((_) {
      _inspections[index].photoCount++;
      notifyListeners();
    });
  }

  void resetInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.resetInspection(_inspections[index].vehicle).then((_) {
      _inspections[index].status = InspectionStatus.pending;
      notifyListeners();
    });
  }

  int get approvedCount =>
      _inspections.where((e) => e.status == InspectionStatus.approved).length;

  int get pendingCount =>
      _inspections.where((e) => e.status == InspectionStatus.pending).length;

  int get flaggedCount =>
      _inspections.where((e) => e.status == InspectionStatus.flagged).length;

  Future<bool> startInspection(String inspectionId) async {
    if (kDebugMode) {
      print('Controller action start: startInspection');
      print('Inspection ID being sent: $inspectionId');
    }
    bool success = false;
    await executeOperation(
      () async {
        success = await _repository.startInspection(inspectionId);
        if (success) {
          final idx = _inspections.indexWhere((element) => element.vehicle == inspectionId);
          if (idx != -1) {
            _inspections[idx].status = InspectionStatus.inProgress;
            notifyListeners();
          }
          if (kDebugMode) {
            print('Controller action success: startInspection');
          }
        }
      },
      onError: "Failed to start inspection",
    );
    if (errorMessage != null) {
      if (kDebugMode) {
        print('Controller action failure: $errorMessage');
      }
    }
    return success;
  }

  Future<bool> completeInspection(String inspectionId, List<Map<String, dynamic>> photos) async {
    if (kDebugMode) {
      print('Controller action start: completeInspection');
      print('Inspection ID being sent: $inspectionId');
      print('Photos payload: $photos');
    }
    bool success = false;
    await executeOperation(
      () async {
        final completedInspection = await _repository.completeInspection(inspectionId, photos);
        final idx = _inspections.indexWhere((element) => element.vehicle == inspectionId);
        if (idx != -1) {
          _inspections[idx] = completedInspection;
          notifyListeners();
        }
        success = true;
        if (kDebugMode) {
          print('Controller action success: completeInspection');
        }
      },
      onError: "Failed to complete inspection",
    );
    if (errorMessage != null) {
      if (kDebugMode) {
        print('Controller action failure: $errorMessage');
      }
    }
    return success;
  }

  Future<bool> failInspection(String inspectionId, String reason, List<String> photos) async {
    if (kDebugMode) {
      print('Controller action start: failInspection');
      print('Inspection ID being sent: $inspectionId');
      print('Reason being sent: $reason');
      print('Photos payload: $photos');
    }
    bool success = false;
    await executeOperation(
      () async {
        final failedInspection = await _repository.failInspection(inspectionId, reason, photos);
        final idx = _inspections.indexWhere((element) => element.vehicle == inspectionId);
        if (idx != -1) {
          _inspections[idx] = failedInspection;
          notifyListeners();
        }
        success = true;
        if (kDebugMode) {
          print('Controller action success: failInspection');
        }
      },
      onError: "Failed to fail inspection",
    );
    if (errorMessage != null) {
      if (kDebugMode) {
        print('Controller action failure: $errorMessage');
      }
    }
    return success;
  }
}
