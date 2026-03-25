import 'package:flutter/material.dart';
import '../core/base/base_viewmodel.dart';

enum InspectionStatus { pending, approved, flagged }

class InspectionModel {
  final String vehicle;
  final String name;
  final String location;
  int photoCount;
  InspectionStatus status;

  InspectionModel({
    required this.vehicle,
    required this.name,
    required this.location,
    this.photoCount = 0,
    this.status = InspectionStatus.pending,
  });
}

class InspectorViewModel extends BaseViewModel {
  List<InspectionModel> _inspections = [];

  List<InspectionModel> get inspections => _inspections;

  Future<void> loadInspections() async {
    await executeOperation(() async {
      await Future.delayed(const Duration(milliseconds: 500));

      _inspections = [
        InspectionModel(
          vehicle: "MH 01 KL 9999",
          name: "Rohit A",
          location: "Tower A, Slot 6",
        ),
        InspectionModel(
          vehicle: "TS 09 XY 1234",
          name: "Ankit S",
          location: "Tower B, Slot 3",
        ),
      ];
    }, onError: "Failed to load inspections");
  }

  void approveInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    _inspections[index].status = InspectionStatus.approved;
    notifyListeners();
  }

  void flagInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    _inspections[index].status = InspectionStatus.flagged;
    notifyListeners();
  }

  void addPhoto(int index) {
    if (index < 0 || index >= _inspections.length) return;

    _inspections[index].photoCount++;
    notifyListeners();
  }

  void resetInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    _inspections[index].status = InspectionStatus.pending;
    notifyListeners();
  }

  int get approvedCount =>
      _inspections.where((e) => e.status == InspectionStatus.approved).length;

  int get pendingCount =>
      _inspections.where((e) => e.status == InspectionStatus.pending).length;

  int get flaggedCount =>
      _inspections.where((e) => e.status == InspectionStatus.flagged).length;
}
