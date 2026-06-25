// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionPhoto _$InspectionPhotoFromJson(Map<String, dynamic> json) =>
    InspectionPhoto(
      url: json['url'] as String? ?? '',
      type: json['type'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
    );

Map<String, dynamic> _$InspectionPhotoToJson(InspectionPhoto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'type': instance.type,
      'timestamp': instance.timestamp,
    };

VerificationHistoryItem _$VerificationHistoryItemFromJson(
        Map<String, dynamic> json) =>
    VerificationHistoryItem(
      verifiedBy: json['verified_by'] as String? ?? '',
      verificationDate: json['verification_date'] as String? ?? '',
      status: json['status'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
    );

Map<String, dynamic> _$VerificationHistoryItemToJson(
        VerificationHistoryItem instance) =>
    <String, dynamic>{
      'verified_by': instance.verifiedBy,
      'verification_date': instance.verificationDate,
      'status': instance.status,
      'remarks': instance.remarks,
    };

RemarkModel _$RemarkModelFromJson(Map<String, dynamic> json) => RemarkModel(
      userName: json['user_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );

Map<String, dynamic> _$RemarkModelToJson(RemarkModel instance) =>
    <String, dynamic>{
      'user_name': instance.userName,
      'role': instance.role,
      'comment': instance.comment,
      'created_at': instance.createdAt,
    };

InspectionModel _$InspectionModelFromJson(Map<String, dynamic> json) =>
    InspectionModel(
      id: _readId(json, 'id') as String,
      bookingId: json['booking_id'] as String?,
      vehicle: json['vehicle_number'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      photoCount: (json['photo_count'] as num?)?.toInt() ?? 0,
      status: $enumDecodeNullable(_$InspectionStatusEnumMap, json['status']) ??
          InspectionStatus.pendingVerification,
      completedAt: json['completed_at'] as String?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => InspectionPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      verifierId: json['verifierId'] as String?,
      verificationNotes: json['verificationNotes'] as String?,
      verifiedAt: json['verifiedAt'] as String?,
      vehicleName: json['vehicle_name'] as String?,
      customerName: json['customer_name'] as String?,
      serviceType: json['service_type'] as String?,
      serviceDate: json['service_date'] as String?,
      assignedSpecialist: json['assigned_specialist'] as String?,
      verificationHistory: (json['verification_history'] as List<dynamic>?)
          ?.map((e) =>
              VerificationHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerNotes: json['customer_notes'] as String?,
      detailerNotes: json['detailer_notes'] as String?,
      remarks: (json['remarks'] as List<dynamic>?)
          ?.map((e) => RemarkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      building: json['building'] as String?,
      street: json['street'] as String?,
      area: json['area'] as String?,
      community: json['community'] as String?,
      vehicleId: json['vehicle_id'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      createdDate: json['created_date'] as String?,
      parkingAvailable: json['parking_available'] as bool?,
      keysProvided: json['keys_provided'] as bool?,
      securityPermission: json['security_permission'] as bool?,
    );

Map<String, dynamic> _$InspectionModelToJson(InspectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'vehicle_number': instance.vehicle,
      'name': instance.name,
      'location': instance.location,
      'photo_count': instance.photoCount,
      'status': _$InspectionStatusEnumMap[instance.status]!,
      'completed_at': instance.completedAt,
      'photos': instance.photos,
      'notes': instance.notes,
      'verifierId': instance.verifierId,
      'verificationNotes': instance.verificationNotes,
      'verifiedAt': instance.verifiedAt,
      'vehicle_name': instance.vehicleName,
      'customer_name': instance.customerName,
      'service_type': instance.serviceType,
      'service_date': instance.serviceDate,
      'assigned_specialist': instance.assignedSpecialist,
      'verification_history': instance.verificationHistory,
      'customer_notes': instance.customerNotes,
      'detailer_notes': instance.detailerNotes,
      'remarks': instance.remarks,
      'building': instance.building,
      'street': instance.street,
      'area': instance.area,
      'community': instance.community,
      'vehicle_id': instance.vehicleId,
      'address': instance.address,
      'city': instance.city,
      'created_date': instance.createdDate,
      'parking_available': instance.parkingAvailable,
      'keys_provided': instance.keysProvided,
      'security_permission': instance.securityPermission,
    };

const _$InspectionStatusEnumMap = {
  InspectionStatus.pending: 'pending',
  InspectionStatus.pendingVerification: 'pendingVerification',
  InspectionStatus.approved: 'approved',
  InspectionStatus.verified: 'verified',
  InspectionStatus.flagged: 'flagged',
  InspectionStatus.inProgress: 'IN_PROGRESS',
  InspectionStatus.completed: 'COMPLETED',
  InspectionStatus.rejected: 'REJECTED',
};
