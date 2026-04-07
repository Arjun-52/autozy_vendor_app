import 'package:json_annotation/json_annotation.dart';

part 'inspection_model.g.dart';

enum InspectionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('flagged')
  flagged,
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

  InspectionModel({
    required this.vehicle,
    required this.name,
    required this.location,
    this.photoCount = 0,
    this.status = InspectionStatus.pending,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) =>
      _$InspectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionModelToJson(this);
}
