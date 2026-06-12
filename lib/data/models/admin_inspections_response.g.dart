// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_inspections_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectorInfo _$InspectorInfoFromJson(Map<String, dynamic> json) =>
    InspectorInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$InspectorInfoToJson(InspectorInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
    };

VehicleInfo _$VehicleInfoFromJson(Map<String, dynamic> json) => VehicleInfo(
      id: json['id'] as String,
      vehicleNumber: json['vehicle_number'] as String,
    );

Map<String, dynamic> _$VehicleInfoToJson(VehicleInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle_number': instance.vehicleNumber,
    };

AdminInspectionRecord _$AdminInspectionRecordFromJson(
        Map<String, dynamic> json) =>
    AdminInspectionRecord(
      id: json['id'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      parkingAvailable: json['parking_available'] as bool?,
      keysProvided: json['keys_provided'] as bool?,
      securityPermission: json['security_permission'] as bool?,
      completedAt: json['completed_at'] as String?,
      scheduledAt: json['scheduled_at'] as String?,
      inspector: json['inspector'] == null
          ? null
          : InspectorInfo.fromJson(json['inspector'] as Map<String, dynamic>),
      vehicle: json['vehicle'] == null
          ? null
          : VehicleInfo.fromJson(json['vehicle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminInspectionRecordToJson(
        AdminInspectionRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'notes': instance.notes,
      'parking_available': instance.parkingAvailable,
      'keys_provided': instance.keysProvided,
      'security_permission': instance.securityPermission,
      'completed_at': instance.completedAt,
      'scheduled_at': instance.scheduledAt,
      'inspector': instance.inspector,
      'vehicle': instance.vehicle,
    };

AdminInspectionsResponse _$AdminInspectionsResponseFromJson(
        Map<String, dynamic> json) =>
    AdminInspectionsResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => AdminInspectionRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$AdminInspectionsResponseToJson(
        AdminInspectionsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'meta': instance.meta,
      'timestamp': instance.timestamp,
    };
