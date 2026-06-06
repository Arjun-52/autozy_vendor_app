// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionPhoto _$InspectionPhotoFromJson(Map<String, dynamic> json) =>
    InspectionPhoto(
      url: json['url'] as String,
      type: json['type'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$InspectionPhotoToJson(InspectionPhoto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'type': instance.type,
      'timestamp': instance.timestamp,
    };

InspectionModel _$InspectionModelFromJson(Map<String, dynamic> json) =>
    InspectionModel(
      vehicle: json['vehicle_number'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      photoCount: (json['photo_count'] as num?)?.toInt() ?? 0,
      status: $enumDecodeNullable(_$InspectionStatusEnumMap, json['status']) ??
          InspectionStatus.pending,
      completedAt: json['completed_at'] as String?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => e is String
              ? InspectionPhoto(url: e, type: 'BEFORE', timestamp: '')
              : InspectionPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$InspectionModelToJson(InspectionModel instance) =>
    <String, dynamic>{
      'vehicle_number': instance.vehicle,
      'name': instance.name,
      'location': instance.location,
      'photo_count': instance.photoCount,
      'status': _$InspectionStatusEnumMap[instance.status]!,
      'completed_at': instance.completedAt,
      'photos': instance.photos?.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
    };

const _$InspectionStatusEnumMap = {
  InspectionStatus.pending: 'pending',
  InspectionStatus.approved: 'approved',
  InspectionStatus.flagged: 'flagged',
  InspectionStatus.inProgress: 'IN_PROGRESS',
  InspectionStatus.completed: 'COMPLETED',
  InspectionStatus.rejected: 'REJECTED',
};
