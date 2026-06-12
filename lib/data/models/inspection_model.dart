import 'package:json_annotation/json_annotation.dart';

part 'inspection_model.g.dart';

enum InspectionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('pendingVerification')
  pendingVerification,
  @JsonValue('approved')
  approved,
  @JsonValue('verified')
  verified,
  @JsonValue('flagged')
  flagged,
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('REJECTED')
  rejected,
}

@JsonSerializable()
class InspectionPhoto {
  final String url;
  final String type;
  final String timestamp;

  InspectionPhoto({
    required this.url,
    required this.type,
    required this.timestamp,
  });

  factory InspectionPhoto.fromJson(Map<String, dynamic> json) =>
      _$InspectionPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionPhotoToJson(this);
}

@JsonSerializable()
class InspectionModel {
  @JsonKey(name: 'vehicle_number')
  final String vehicle;
  final String name;
  final String location;
  @JsonKey(name: 'photo_count')
  int photoCount;
  InspectionStatus status;
  @JsonKey(name: 'completed_at')
  String? completedAt;
  List<InspectionPhoto>? photos;
  String? notes;
  String? verifierId;
  String? verificationNotes;
  String? verifiedAt;

  @JsonKey(ignore: true)
  List<Map<String, String>> uploadedPhotos = [];

  InspectionModel({
    required this.vehicle,
    required this.name,
    required this.location,
    this.photoCount = 0,
    this.status = InspectionStatus.pendingVerification,
    this.completedAt,
    this.photos,
    this.notes,
    this.verifierId,
    this.verificationNotes,
    this.verifiedAt,
  }) {
    uploadedPhotos = [];
  }
  factory InspectionModel.fromJson(Map<String, dynamic> json) =>
      _$InspectionModelFromJson(json);

  /// Queue‑specific constructor – parses the payload returned by /api/v1/inspections/queue
  /// The backend schema differs from the UI model, so we map fields safely.
  factory InspectionModel.fromQueueJson(Map<String, dynamic> json) {
    // Nested vehicle object may contain the vehicle_number we need.
    final vehicleMap = json['vehicle'] as Map<String, dynamic>?;
    String vehicleNumber = vehicleMap != null ?
        (vehicleMap['vehicle_number']?.toString() ?? '') : '';

    // Helper to map backend status strings to our enum.
    InspectionStatus mapStatus(String? status) {
      switch (status) {
        case 'SCHEDULED':
        return InspectionStatus.inProgress;
        case 'APPROVED':
          return InspectionStatus.approved;
        case 'VERIFIED':
          return InspectionStatus.verified;
        case 'FLAGGED':
          return InspectionStatus.flagged;
        case 'IN_PROGRESS':
          return InspectionStatus.inProgress;
        case 'COMPLETED':
          return InspectionStatus.completed;
        case 'REJECTED':
          return InspectionStatus.rejected;
        case 'PENDING':
          return InspectionStatus.pending;
        default:
          // Fallback to a safe default – treat unknown as pendingVerification.
          return InspectionStatus.pendingVerification;
      }
    }

    return InspectionModel(
      vehicle: vehicleNumber,
      // The queue endpoint does not provide name / location – fallback to empty strings.
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      photoCount: (json['photo_count'] as int?) ?? 0,
      status: mapStatus(json['status'] as String?),
      completedAt: json['completed_at']?.toString(),
      // Photos, notes, verifier fields are not present in the queue response; keep them null.
      photos: null,
      notes: json['notes']?.toString(),
      verifierId: json['inspector_id']?.toString(),
      verificationNotes: json['inspector_comments']?.toString(),
      verifiedAt: json['completed_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => _$InspectionModelToJson(this);
}
