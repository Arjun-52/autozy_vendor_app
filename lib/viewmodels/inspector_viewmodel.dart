import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../core/base/base_viewmodel.dart';
import '../core/interfaces/inspector_repository_interface.dart';
import '../data/models/inspection_model.dart';

class InspectorViewModel extends BaseViewModel {
  final IInspectorRepository _repository;

  InspectorViewModel(this._repository);

  List<InspectionModel> _inspections = [];

  List<InspectionModel> get inspections => _inspections;

  // Pending verifications fetched separately
  List<InspectionModel> _pendingVerifications = [];
  List<InspectionModel> get pendingVerifications => _pendingVerifications;

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

  // Load pending verifications for inspector
  Future<void> loadPendingVerifications() async {
    if (kDebugMode) {
      print('Controller fetch start: loadPendingVerifications');
    }
    await executeOperation(
      () async {
        _pendingVerifications = await _repository.fetchPendingVerifications();
      },
      onError: "Failed to load pending verifications",
      onSuccess: () {
        if (kDebugMode) {
          print('Controller fetch success: loaded ${_pendingVerifications.length} pending verifications');
        }
      },
    );
    if (errorMessage != null) {
      if (kDebugMode) {
        print('Controller fetch failure: $errorMessage');
      }
    }
  }

  // Approve a verification
  Future<void> approveVerification(String inspectionId) async {
    await executeOperation(
      () async {
        await _repository.approveVerification(inspectionId);
        // Update local list status
        int idx = _pendingVerifications.indexWhere((e) => e.vehicle == inspectionId);
        if (idx != -1) {
          _pendingVerifications[idx].status = InspectionStatus.approved;
        }
        // Optionally refresh inspections list
        await loadInspections();
      },
      onError: "Failed to approve verification",
    );
  }

  // Reject a verification with reason and optional photos
  Future<void> rejectVerification(String inspectionId, String reason, List<File> photos) async {
    await executeOperation(
      () async {
        await _repository.rejectVerification(inspectionId, reason, photos);
        int idx = _pendingVerifications.indexWhere((e) => e.vehicle == inspectionId);
        if (idx != -1) {
          _pendingVerifications[idx].status = InspectionStatus.rejected;
        }
        await loadInspections();
      },
      onError: "Failed to reject verification",
    );
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
      _inspections.where((e) => e.status == InspectionStatus.pendingVerification).length;

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

  bool _isUploadingImage = false;
  bool get isUploadingImage => _isUploadingImage;

  String? _uploadingVehicle;
  String? get uploadingVehicle => _uploadingVehicle;

  Future<void> uploadImage(String vehicleNumber) async {
    if (kDebugMode) {
      print('Take Photo tapped. Inspection ID: $vehicleNumber');
    }

    // Open Camera / Gallery Permission is implicit in picker but we catch denials
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    try {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } catch (e) {
      if (kDebugMode) {
        print('Camera/Gallery Permission Denied or Pick Failed: $e');
      }
      setError("Camera or Gallery permission denied");
      return;
    }

    if (pickedFile == null) {
      if (kDebugMode) {
        print('Image selection cancelled by user.');
      }
      return;
    }

    if (kDebugMode) {
      print('Image selected: ${pickedFile.path}');
    }

    _isUploadingImage = true;
    _uploadingVehicle = vehicleNumber;
    setError(null);
    notifyListeners();

    if (kDebugMode) {
      print('Upload request start. Inspection ID: $vehicleNumber');
    }

    try {
      final file = File(pickedFile.path);
      final response = await _repository.uploadImage(file);

      if (response.success) {
        if (kDebugMode) {
          print('Upload success. URL received: ${response.data.url}, Key received: ${response.data.key}');
        }

        final idx = _inspections.indexWhere((element) => element.vehicle == vehicleNumber);
        if (idx != -1) {
          // Store returned URL and key
          _inspections[idx].uploadedPhotos.add({
            'url': response.data.url,
            'key': response.data.key,
          });
          // Update photo count
          _inspections[idx].photoCount = _inspections[idx].uploadedPhotos.length;

          if (kDebugMode) {
            print('Controller update success. New count: ${_inspections[idx].photoCount}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Upload failure: response success field is false');
        }
        setError("Upload failed: API error");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Upload failure: $e');
      }
      setError("Upload failed: $e");
    } finally {
      _isUploadingImage = false;
      _uploadingVehicle = null;
      notifyListeners();
    }
  }
}
