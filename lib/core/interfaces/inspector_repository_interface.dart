import 'dart:io';
import '../../data/models/inspection_model.dart';
import '../../data/models/upload_image_response.dart';

/// Repository interface for Inspector operations
/// Enables loose coupling and easy API integration
abstract class IInspectorRepository {
  /// Upload image
  Future<UploadImageResponse> uploadImage(File file);
  /// Get all inspections (combined assigned + unassigned)
  Future<List<InspectionModel>> getInspections();

  /// Get only assigned inspections for this inspector
  Future<List<InspectionModel>> getAssignedInspections();

  /// Get only unassigned (claimable) inspections in the queue
  Future<List<InspectionModel>> getUnassignedInspections();

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

  /// Claim inspection status
  Future<InspectionModel> claimInspection(String inspectionId);

  /// Complete inspection status
  Future<InspectionModel> completeInspection(String inspectionId, List<Map<String, dynamic>> photos, {String? notes});

  /// Fail inspection status
  Future<InspectionModel> failInspection(String inspectionId, String reason, List<String> photos);

  /// Get inspection by subscription ID
  Future<InspectionModel?> getInspectionBySubscription(String subscriptionId);

  /// Fetch pending verifications for inspectors
  Future<List<InspectionModel>> fetchPendingVerifications();

  /// Approve a verification
  Future<void> approveVerification(String inspectionId, {String? remarks, List<Map<String, dynamic>>? photos});

  /// Reject a verification with reason and optional photos
  Future<void> rejectVerification(String inspectionId, String reason, List<String> photoUrls);

  /// Add comment to service
  Future<void> addComment(String serviceId, String comment);

}
