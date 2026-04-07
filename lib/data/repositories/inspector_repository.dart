import '../../core/interfaces/inspector_repository_interface.dart';
import '../../data/models/inspection_model.dart';

/// Mock implementation of InspectorRepository
/// Returns existing mock data to maintain backward compatibility
class InspectorRepository implements IInspectorRepository {
  @override
  Future<List<InspectionModel>> getInspections() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return existing mock data - EXACTLY SAME as before
    return [
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
  }

  @override
  Future<bool> approveInspection(String inspectionId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // Always succeed for now
  }

  @override
  Future<bool> flagInspection(String inspectionId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // Always succeed for now
  }

  @override
  Future<bool> addPhoto(String inspectionId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 200));
    return true; // Always succeed for now
  }

  @override
  Future<bool> resetInspection(String inspectionId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // Always succeed for now
  }
}
