import 'package:json_annotation/json_annotation.dart';

part 'inspection_model.g.dart';

enum InspectionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
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

  InspectionModel({
    required this.vehicle,
    required this.name,
    required this.location,
    this.photoCount = 0,
    this.status = InspectionStatus.pending,
    this.completedAt,
    this.photos,
    this.notes,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) =>
      _$InspectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionModelToJson(this);
}
