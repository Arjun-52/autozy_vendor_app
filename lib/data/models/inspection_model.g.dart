// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionModel _$InspectionModelFromJson(Map<String, dynamic> json) =>
    InspectionModel(
      vehicle: json['vehicle_number'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      photoCount: (json['photo_count'] as num?)?.toInt() ?? 0,
      status: $enumDecodeNullable(_$InspectionStatusEnumMap, json['status']) ??
          InspectionStatus.pending,
    );

Map<String, dynamic> _$InspectionModelToJson(InspectionModel instance) =>
    <String, dynamic>{
      'vehicle_number': instance.vehicle,
      'name': instance.name,
      'location': instance.location,
      'photo_count': instance.photoCount,
      'status': _$InspectionStatusEnumMap[instance.status]!,
    };

const _$InspectionStatusEnumMap = {
  InspectionStatus.pending: 'pending',
  InspectionStatus.approved: 'approved',
  InspectionStatus.flagged: 'flagged',
};
