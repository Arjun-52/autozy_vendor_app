import '../../data/models/inspection_model.dart';

/// Repository interface for Inspector operations
/// Enables loose coupling and easy API integration
abstract class IInspectorRepository {
  /// Get all inspections
  Future<List<InspectionModel>> getInspections();

  /// Approve an inspection
  Future<bool> approveInspection(String inspectionId);

  /// Flag an inspection
  Future<bool> flagInspection(String inspectionId);

  /// Add photo to inspection
  Future<bool> addPhoto(String inspectionId);

  /// Reset inspection status
  Future<bool> resetInspection(String inspectionId);
}
