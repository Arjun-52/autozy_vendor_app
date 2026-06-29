// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassign_detailer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReassignDetailerResponse _$ReassignDetailerResponseFromJson(
        Map<String, dynamic> json) =>
    ReassignDetailerResponse(
      success: json['success'] as bool,
      data: ReassignedRecord.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$ReassignDetailerResponseToJson(
        ReassignDetailerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.toJson(),
      'timestamp': instance.timestamp,
    };

ReassignedRecord _$ReassignedRecordFromJson(Map<String, dynamic> json) =>
    ReassignedRecord(
      id: json['id'] as String,
      subscriptionId: json['subscription_id'] as String,
      vehicleId: json['vehicle_id'] as String,
      detailerId: json['detailer_id'] as String,
      serviceDate: json['service_date'] as String,
      serviceType: json['service_type'] as String,
      status: json['status'] as String,
      verificationStatus: json['verification_status'] as String,
      createdAt: json['created_at'] as String,
      vehicle: json['vehicle'] as Map<String, dynamic>?,
      detailer: json['detailer'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ReassignedRecordToJson(ReassignedRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subscription_id': instance.subscriptionId,
      'vehicle_id': instance.vehicleId,
      'detailer_id': instance.detailerId,
      'service_date': instance.serviceDate,
      'service_type': instance.serviceType,
      'status': instance.status,
      'verification_status': instance.verificationStatus,
      'created_at': instance.createdAt,
      'vehicle': instance.vehicle,
      'detailer': instance.detailer,
    };
