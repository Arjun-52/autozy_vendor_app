import 'dart:io';
import '../../data/models/inspection_model.dart';
import '../../data/models/upload_image_response.dart';

/// Repository interface for Inspector operations
/// Enables loose coupling and easy API integration
abstract class IInspectorRepository {
  /// Upload image
  Future<UploadImageResponse> uploadImage(File file);
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

  /// Start inspection status
  Future<bool> startInspection(String inspectionId);

  /// Complete inspection status
  Future<InspectionModel> completeInspection(String inspectionId, List<Map<String, dynamic>> photos);

  /// Fail inspection status
  Future<InspectionModel> failInspection(String inspectionId, String reason, List<String> photos);

  /// Get inspection by subscription ID
  Future<InspectionModel?> getInspectionBySubscription(String subscriptionId);
}
