import 'package:json_annotation/json_annotation.dart';
import 'pagination_meta.dart';

part 'admin_inspections_response.g.dart';

@JsonSerializable()
class InspectorInfo {
  final String id;
  final String name;
  final String role;

  InspectorInfo({
    required this.id,
    required this.name,
    required this.role,
  });

  factory InspectorInfo.fromJson(Map<String, dynamic> json) =>
      _$InspectorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$InspectorInfoToJson(this);
}

@JsonSerializable()
class VehicleInfo {
  final String id;
  @JsonKey(name: 'vehicle_number')
  final String vehicleNumber;

  VehicleInfo({
    required this.id,
    required this.vehicleNumber,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleInfoToJson(this);
}

@JsonSerializable()
class AdminInspectionRecord {
  final String id;
  final String status;
  final String? notes;
  @JsonKey(name: 'parking_available')
  final bool? parkingAvailable;
  @JsonKey(name: 'keys_provided')
  final bool? keysProvided;
  @JsonKey(name: 'security_permission')
  final bool? securityPermission;
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @JsonKey(name: 'scheduled_at')
  final String? scheduledAt;
  final InspectorInfo? inspector;
  final VehicleInfo? vehicle;

  AdminInspectionRecord({
    required this.id,
    required this.status,
    this.notes,
    this.parkingAvailable,
    this.keysProvided,
    this.securityPermission,
    this.completedAt,
    this.scheduledAt,
    this.inspector,
    this.vehicle,
  });

  factory AdminInspectionRecord.fromJson(Map<String, dynamic> json) =>
      _$AdminInspectionRecordFromJson(json);

  Map<String, dynamic> toJson() => _$AdminInspectionRecordToJson(this);
}

@JsonSerializable()
class AdminInspectionsResponse {
  final bool success;
  final List<AdminInspectionRecord> data;
  final PaginationMeta meta;
  final String? timestamp;

  AdminInspectionsResponse({
    required this.success,
    required this.data,
    required this.meta,
    this.timestamp,
  });

  factory AdminInspectionsResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminInspectionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdminInspectionsResponseToJson(this);
}
