import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../core/base/base_viewmodel.dart';
import '../core/interfaces/inspector_repository_interface.dart';
import '../data/models/inspection_model.dart';
import '../data/models/area_model.dart';

class InspectorViewModel extends BaseViewModel {
  final IInspectorRepository _repository;

  InspectorViewModel(this._repository) {
    initAreas();
  }

  List<InspectionModel> _inspections = [];

  List<InspectionModel> get inspections => _inspections;

  // Pending verifications fetched separately
  List<InspectionModel> _pendingVerifications = [];
  List<InspectionModel> get pendingVerifications => _pendingVerifications;

  String? _selectedArea;
  String? _selectedBuilding;
  String? _selectedStreet;
  String? _selectedCommunity;
  String _filterSearchQuery = '';

  String? get selectedArea => _selectedArea;
  String? get selectedBuilding => _selectedBuilding;
  String? get selectedStreet => _selectedStreet;
  String? get selectedCommunity => _selectedCommunity;
  String get filterSearchQuery => _filterSearchQuery;

  void setFilters({String? area, String? building, String? street, String? community}) {
    _selectedArea = area;
    _selectedBuilding = building;
    _selectedStreet = street;
    _selectedCommunity = community;
    notifyListeners();
  }

  void clearFilters() {
    _selectedArea = null;
    _selectedBuilding = null;
    _selectedStreet = null;
    _selectedCommunity = null;
    _filterSearchQuery = '';
    notifyListeners();
  }

  void removeAreaFilter() {
    _selectedArea = null;
    notifyListeners();
  }

  void removeBuildingFilter() {
    _selectedBuilding = null;
    notifyListeners();
  }

  void removeStreetFilter() {
    _selectedStreet = null;
    notifyListeners();
  }

  void removeCommunityFilter() {
    _selectedCommunity = null;
    notifyListeners();
  }

  void setFilterSearchQuery(String query) {
    _filterSearchQuery = query;
    notifyListeners();
  }

  bool get hasActiveFilters =>
      _selectedArea != null ||
      _selectedBuilding != null ||
      _selectedStreet != null ||
      _selectedCommunity != null;

  List<AreaModel> _areas = [];
  List<AreaModel> get areas => _areas;

  void initAreas() {
    if (_areas.isNotEmpty) return;
    _areas = [
      AreaModel(
        id: '1',
        name: 'Gachibowli',
        code: 'GB',
        description: 'West Hyderabad area',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        assignedBuildings: ['My Home Bhooja', 'Prestige High Fields', 'My Home Avatar'],
      ),
      AreaModel(
        id: '2',
        name: 'Financial District',
        code: 'FD',
        description: 'West Hyderabad Financial District',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 20)),
        assignedBuildings: ['SAS Crown', 'Prestige Beverly Hills'],
      ),
      AreaModel(
        id: '3',
        name: 'Kondapur',
        code: 'KP',
        description: 'Kondapur residential region',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
        assignedBuildings: ['Aparna Serene Park', 'Aparna Luxor Park'],
      ),
    ];
  }

  List<String> get availableBuildingsForAssignment {
    final list = _inspections
        .map((e) => e.building)
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    final standardBuildings = [
      'My Home Bhooja',
      'Prestige High Fields',
      'My Home Avatar',
      'SAS Crown',
      'Prestige Beverly Hills',
      'Aparna Serene Park',
      'Aparna Luxor Park',
      'Aparna Sarovar',
      'Block 1',
      'Block 2',
      'Tower A',
      'Tower B',
    ];
    for (final b in standardBuildings) {
      if (!list.contains(b)) {
        list.add(b);
      }
    }
    list.sort();
    return list;
  }

  bool isDuplicateAreaName(String name, {String? excludeId}) {
    final search = name.trim().toLowerCase();
    for (final area in _areas) {
      if (excludeId != null && area.id == excludeId) {
        continue;
      }
      if (area.name.trim().toLowerCase() == search) {
        return true;
      }
    }
    return false;
  }

  void createArea(String name, String? code, String? description, bool isActive) {
    if (isDuplicateAreaName(name)) {
      throw Exception('An area with this name already exists.');
    }
    final newArea = AreaModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      code: code?.trim(),
      description: description?.trim(),
      isActive: isActive,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      assignedBuildings: [],
    );
    _areas.insert(0, newArea);
    notifyListeners();
  }

  void editArea(String id, String name, String? code, String? description, bool isActive) {
    if (isDuplicateAreaName(name, excludeId: id)) {
      throw Exception('An area with this name already exists.');
    }
    final idx = _areas.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _areas[idx].name = name.trim();
      _areas[idx].code = code?.trim();
      _areas[idx].description = description?.trim();
      _areas[idx].isActive = isActive;
      _areas[idx].updatedAt = DateTime.now();
      notifyListeners();
    }
  }

  void assignBuildings(String areaId, List<String> buildingNames) {
    final idx = _areas.indexWhere((e) => e.id == areaId);
    if (idx != -1) {
      for (final area in _areas) {
        if (area.id != areaId) {
          area.assignedBuildings.removeWhere((b) => buildingNames.contains(b));
        }
      }
      
      final current = _areas[idx].assignedBuildings;
      for (final b in buildingNames) {
        if (!current.contains(b)) {
          current.add(b);
        }
      }
      _areas[idx].updatedAt = DateTime.now();
      notifyListeners();
    }
  }

  void removeBuildingFromArea(String areaId, String buildingName) {
    final idx = _areas.indexWhere((e) => e.id == areaId);
    if (idx != -1) {
      _areas[idx].assignedBuildings.remove(buildingName);
      _areas[idx].updatedAt = DateTime.now();
      notifyListeners();
    }
  }

  void deleteArea(String id) {
    _areas.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  String? resolveAreaForBuilding(String? building) {
    if (building == null || building.isEmpty) return null;
    for (final area in _areas) {
      if (area.isActive && area.assignedBuildings.contains(building)) {
        return area.name;
      }
    }
    return null;
  }

  List<String> get uniqueAreas {
    final list = _inspections.map((e) => resolveAreaForBuilding(e.building) ?? e.area).whereType<String>().where((e) => e.isNotEmpty).toSet().toList();
    for (final area in _areas) {
      if (area.isActive && !list.contains(area.name)) {
        list.add(area.name);
      }
    }
    list.sort();
    return list;
  }

  List<String> get uniqueBuildings => _inspections.map((e) => e.building).whereType<String>().where((e) => e.isNotEmpty).toSet().toList()..sort();
  List<String> get uniqueStreets => _inspections.map((e) => e.street).whereType<String>().where((e) => e.isNotEmpty).toSet().toList()..sort();
  List<String> get uniqueCommunities => _inspections.map((e) => e.community).whereType<String>().where((e) => e.isNotEmpty).toSet().toList()..sort();

  List<InspectionModel> get filteredInspections {
    return _inspections.where((inspection) {
      if (_selectedArea != null) {
        final resolvedArea = resolveAreaForBuilding(inspection.building);
        final actualArea = resolvedArea ?? inspection.area;
        if (actualArea != _selectedArea) return false;
      }
      if (_selectedBuilding != null && inspection.building != _selectedBuilding) return false;
      if (_selectedStreet != null && inspection.street != _selectedStreet) return false;
      if (_selectedCommunity != null && inspection.community != _selectedCommunity) return false;
      return true;
    }).toList();
  }

  List<InspectionModel> get filteredPendingVerifications {
    return _pendingVerifications.where((inspection) {
      if (_selectedArea != null) {
        final resolvedArea = resolveAreaForBuilding(inspection.building);
        final actualArea = resolvedArea ?? inspection.area;
        if (actualArea != _selectedArea) return false;
      }
      if (_selectedBuilding != null && inspection.building != _selectedBuilding) return false;
      if (_selectedStreet != null && inspection.street != _selectedStreet) return false;
      if (_selectedCommunity != null && inspection.community != _selectedCommunity) return false;
      return true;
    }).toList();
  }

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
  Future<void> approveVerification(String inspectionId, {String? remarks}) async {
    await executeOperation(
      () async {
        await _repository.approveVerification(inspectionId);
        
        final timestamp = DateTime.now().toLocal().toString().split('.')[0];
        
        // Find and update local list status
        int idx = _pendingVerifications.indexWhere((e) => e.id == inspectionId);
        if (idx != -1) {
          final inspection = _pendingVerifications[idx];
          inspection.status = InspectionStatus.verified;
          inspection.verifiedAt = timestamp;
          inspection.verificationNotes = remarks;
          
          inspection.verificationHistory ??= [];
          inspection.verificationHistory!.insert(0, VerificationHistoryItem(
            verifiedBy: 'Inspector Mode',
            verificationDate: timestamp,
            status: 'Verified',
            remarks: remarks ?? 'Verified successfully',
          ));
        }

        int mainIdx = _inspections.indexWhere((e) => e.id == inspectionId);
        if (mainIdx != -1) {
          final inspection = _inspections[mainIdx];
          inspection.status = InspectionStatus.verified;
          inspection.verifiedAt = timestamp;
          inspection.verificationNotes = remarks;
          
          inspection.verificationHistory ??= [];
          inspection.verificationHistory!.insert(0, VerificationHistoryItem(
            verifiedBy: 'Inspector Mode',
            verificationDate: timestamp,
            status: 'Verified',
            remarks: remarks ?? 'Verified successfully',
          ));
        }
        notifyListeners();
        // Optionally refresh inspections list
        await loadInspections();
      },
      onError: "Failed to approve verification",
    );
  }

  // Reject a verification with reason and optional photos
  Future<void> rejectVerification(String inspectionId, String reason, {String? remarks}) async {
    await executeOperation(
      () async {
        await _repository.rejectVerification(inspectionId, reason, []);
        
        final timestamp = DateTime.now().toLocal().toString().split('.')[0];
        final combinedRemarks = remarks != null && remarks.isNotEmpty 
            ? '$reason. Remarks: $remarks' 
            : reason;

        int idx = _pendingVerifications.indexWhere((e) => e.id == inspectionId);
        if (idx != -1) {
          final inspection = _pendingVerifications[idx];
          inspection.status = InspectionStatus.rejected;
          inspection.notes = reason;
          inspection.verificationNotes = combinedRemarks;
          inspection.verifiedAt = timestamp;
          
          inspection.verificationHistory ??= [];
          inspection.verificationHistory!.insert(0, VerificationHistoryItem(
            verifiedBy: 'Inspector Mode',
            verificationDate: timestamp,
            status: 'Rejected',
            remarks: combinedRemarks,
          ));
        }

        int mainIdx = _inspections.indexWhere((e) => e.id == inspectionId);
        if (mainIdx != -1) {
          final inspection = _inspections[mainIdx];
          inspection.status = InspectionStatus.rejected;
          inspection.notes = reason;
          inspection.verificationNotes = combinedRemarks;
          inspection.verifiedAt = timestamp;
          
          inspection.verificationHistory ??= [];
          inspection.verificationHistory!.insert(0, VerificationHistoryItem(
            verifiedBy: 'Inspector Mode',
            verificationDate: timestamp,
            status: 'Rejected',
            remarks: combinedRemarks,
          ));
        }
        notifyListeners();
        await loadInspections();
      },
      onError: "Failed to reject verification",
    );
  }

  Future<void> uploadProofPhoto(String inspectionId, String type, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    try {
      pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Camera/Gallery Permission Denied or Pick Failed: $e');
      }
      setError("Camera or Gallery permission denied");
      return;
    }

    if (pickedFile == null) {
      return;
    }

    _isUploadingImage = true;
    _uploadingInspectionId = inspectionId;
    setError(null);
    notifyListeners();

    try {
      final file = File(pickedFile.path);
      final response = await _repository.uploadImage(file);

      if (response.success) {
        final inspectionIdx = _inspections.indexWhere((element) => element.id == inspectionId);
        final pendingIdx = _pendingVerifications.indexWhere((element) => element.id == inspectionId);

        final newPhoto = InspectionPhoto(
          url: response.data.url,
          type: type,
          timestamp: DateTime.now().toUtc().toIso8601String(),
        );

        if (inspectionIdx != -1) {
          _inspections[inspectionIdx].photos ??= [];
          _inspections[inspectionIdx].photos!.add(newPhoto);
          _inspections[inspectionIdx].photoCount = _inspections[inspectionIdx].photos!.length;
        }
        if (pendingIdx != -1) {
          _pendingVerifications[pendingIdx].photos ??= [];
          _pendingVerifications[pendingIdx].photos!.add(newPhoto);
          _pendingVerifications[pendingIdx].photoCount = _pendingVerifications[pendingIdx].photos!.length;
        }
        notifyListeners();
      } else {
        setError("Upload failed: API error");
      }
    } catch (e) {
      setError("Upload failed: $e");
    } finally {
      _isUploadingImage = false;
      _uploadingInspectionId = null;
      notifyListeners();
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
    _repository.approveInspection(_inspections[index].id).then((_) {
      _inspections[index].status = InspectionStatus.approved;
      notifyListeners();
    });
  }

  void flagInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.flagInspection(_inspections[index].id).then((_) {
      _inspections[index].status = InspectionStatus.flagged;
      notifyListeners();
    });
  }

  void addPhoto(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.addPhoto(_inspections[index].id).then((_) {
      _inspections[index].photoCount++;
      notifyListeners();
    });
  }

  void resetInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.resetInspection(_inspections[index].id).then((_) {
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
          final idx = _inspections.indexWhere((element) => element.id == inspectionId);
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

      // Print the entire inspection object before calling completeInspection()
      try {
        final targetInspection = _inspections.firstWhere((element) => element.id == inspectionId);
        print('Inspection object details before completion: ${jsonEncode(targetInspection.toJson())}');
      } catch (e) {
        print('Error printing inspection object: $e');
      }
    }
    bool success = false;
    await executeOperation(
      () async {
        final completedInspection = await _repository.completeInspection(inspectionId, photos);
        final idx = _inspections.indexWhere((element) => element.id == inspectionId);
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
        final idx = _inspections.indexWhere((element) => element.id == inspectionId);
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

  String? _uploadingInspectionId;
  String? get uploadingInspectionId => _uploadingInspectionId;

  Future<void> uploadImage(String inspectionId) async {
    if (kDebugMode) {
      print('Take Photo tapped. Inspection ID: $inspectionId');
    }

    // Open Camera / Gallery Permission is implicit in picker but we catch denials
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    try {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );
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
    _uploadingInspectionId = inspectionId;
    setError(null);
    notifyListeners();

    if (kDebugMode) {
      print('Upload request start. Inspection ID: $inspectionId');
    }

    try {
      final file = File(pickedFile.path);
      final response = await _repository.uploadImage(file);

      if (response.success) {
        if (kDebugMode) {
          print('Upload success. URL received: ${response.data.url}, Key received: ${response.data.key}');
        }

        final idx = _inspections.indexWhere((element) => element.id == inspectionId);
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
      _uploadingInspectionId = null;
      notifyListeners();
    }
  }

  Future<void> addComment(String serviceId, String comment) async {
    await executeOperation(
      () async {
        await _repository.addComment(serviceId, comment);
        
        final timestamp = DateTime.now().toLocal().toString().split('.')[0];
        final newRemark = RemarkModel(
          userName: 'Inspector Mode',
          role: 'Inspector',
          comment: comment,
          createdAt: timestamp,
        );

        final pendingIdx = _pendingVerifications.indexWhere((element) => element.id == serviceId);
        if (pendingIdx != -1) {
          _pendingVerifications[pendingIdx].remarks ??= [];
          _pendingVerifications[pendingIdx].remarks!.insert(0, newRemark);
        }
        final mainIdx = _inspections.indexWhere((element) => element.id == serviceId);
        if (mainIdx != -1) {
          _inspections[mainIdx].remarks ??= [];
          _inspections[mainIdx].remarks!.insert(0, newRemark);
        }
        notifyListeners();
      },
      onError: "Failed to add comment",
    );
  }

  void addRemarkFromDetailer(String vehicle, String? reason, String? comment) {
    final timestamp = DateTime.now().toLocal().toString().split('.')[0];
    String remarkText = '';
    if (reason != null && reason.isNotEmpty && comment != null && comment.isNotEmpty) {
      remarkText = 'Reason: $reason. Notes: $comment';
    } else if (reason != null && reason.isNotEmpty) {
      remarkText = 'Reason: $reason';
    } else if (comment != null && comment.isNotEmpty) {
      remarkText = comment;
    } else {
      return;
    }

    final newRemark = RemarkModel(
      userName: 'Detailer',
      role: 'Detailer',
      comment: remarkText,
      createdAt: timestamp,
    );

    final idx = _inspections.indexWhere((e) => e.vehicle == vehicle);
    if (idx != -1) {
      _inspections[idx].remarks ??= [];
      _inspections[idx].remarks!.insert(0, newRemark);
    }

    if (_currentSubscriptionInspection != null && _currentSubscriptionInspection!.vehicle == vehicle) {
      _currentSubscriptionInspection!.remarks ??= [];
      _currentSubscriptionInspection!.remarks!.insert(0, newRemark);
    }

    final pendingIdx = _pendingVerifications.indexWhere((e) => e.vehicle == vehicle);
    if (pendingIdx != -1) {
      _pendingVerifications[pendingIdx].remarks ??= [];
      _pendingVerifications[pendingIdx].remarks!.insert(0, newRemark);
    }

    notifyListeners();
  }

  void updateRemarkFromDetailer(String vehicle, String? oldReason, String? oldComment, String? newReason, String? newComment) {
    final timestamp = DateTime.now().toLocal().toString().split('.')[0];
    
    String getRemarkText(String? reason, String? comment) {
      if (reason != null && reason.isNotEmpty && comment != null && comment.isNotEmpty) {
        return 'Reason: $reason. Notes: $comment';
      } else if (reason != null && reason.isNotEmpty) {
        return 'Reason: $reason';
      } else if (comment != null && comment.isNotEmpty) {
        return comment;
      }
      return '';
    }

    final oldText = getRemarkText(oldReason, oldComment);
    final newText = getRemarkText(newReason, newComment);
    if (oldText.isEmpty || newText.isEmpty) return;

    void updateList(List<InspectionModel> list) {
      for (final inspection in list) {
        if (inspection.vehicle == vehicle && inspection.remarks != null) {
          final remarkIdx = inspection.remarks!.indexWhere((r) => r.comment == oldText && r.role.toLowerCase() == 'detailer');
          if (remarkIdx != -1) {
            inspection.remarks![remarkIdx] = RemarkModel(
              userName: 'Detailer',
              role: 'Detailer',
              comment: newText,
              createdAt: timestamp,
            );
          }
        }
      }
    }

    updateList(_inspections);
    updateList(_pendingVerifications);
    if (_currentSubscriptionInspection != null && _currentSubscriptionInspection!.vehicle == vehicle && _currentSubscriptionInspection!.remarks != null) {
      final remarkIdx = _currentSubscriptionInspection!.remarks!.indexWhere((r) => r.comment == oldText && r.role.toLowerCase() == 'detailer');
      if (remarkIdx != -1) {
        _currentSubscriptionInspection!.remarks![remarkIdx] = RemarkModel(
          userName: 'Detailer',
          role: 'Detailer',
          comment: newText,
          createdAt: timestamp,
        );
      }
    }
    notifyListeners();
  }

  void reportIssueFromDetailer(String vehicle, String reason, String comment) {
    final timestamp = DateTime.now().toLocal().toString().split('.')[0];
    final newRemark = RemarkModel(
      userName: 'Detailer',
      role: 'Detailer',
      comment: comment.isNotEmpty ? '[Issue Filed] Reason: $reason. Notes: $comment' : '[Issue Filed] Reason: $reason',
      createdAt: timestamp,
    );

    final idx = _inspections.indexWhere((e) => e.vehicle == vehicle);
    if (idx != -1) {
      _inspections[idx].remarks ??= [];
      _inspections[idx].remarks!.insert(0, newRemark);
      _inspections[idx].status = InspectionStatus.flagged;
    }

    if (_currentSubscriptionInspection != null && _currentSubscriptionInspection!.vehicle == vehicle) {
      _currentSubscriptionInspection!.remarks ??= [];
      _currentSubscriptionInspection!.remarks!.insert(0, newRemark);
      _currentSubscriptionInspection!.status = InspectionStatus.flagged;
    }

    final pendingIdx = _pendingVerifications.indexWhere((e) => e.vehicle == vehicle);
    if (pendingIdx != -1) {
      _pendingVerifications[pendingIdx].remarks ??= [];
      _pendingVerifications[pendingIdx].remarks!.insert(0, newRemark);
      _pendingVerifications[pendingIdx].status = InspectionStatus.flagged;
    }

    notifyListeners();
  }
}
