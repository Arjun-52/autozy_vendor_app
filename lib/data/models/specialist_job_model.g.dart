// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialist_job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialistJobModel _$SpecialistJobModelFromJson(Map<String, dynamic> json) =>
    SpecialistJobModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      vehicleId: json['vehicle_id'] as String,
      addonServiceId: json['addon_service_id'] as String,
      specialistId: json['specialist_id'] as String,
      status: json['status'] as String,
      scheduledDate: json['scheduled_date'] as String,
      scheduledSlotStart: json['scheduled_slot_start'] as String,
      scheduledSlotEnd: json['scheduled_slot_end'] as String,
      addonService: SpecialistAddonService.fromJson(
          json['addon_service'] as Map<String, dynamic>),
      vehicle:
          SpecialistVehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      user: SpecialistUser.fromJson(json['user'] as Map<String, dynamic>),
      supervisorAuditStatus: json['supervisor_audit_status'] as String?,
      disputeWindowEnd: json['dispute_window_end'] as String?,
      beforePhotos: (json['before_photos'] as List<dynamic>?)
          ?.map((e) => SpecialistPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      afterPhotos: (json['after_photos'] as List<dynamic>?)
          ?.map((e) => SpecialistPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialistNotes: json['specialist_notes'] as String?,
    );

Map<String, dynamic> _$SpecialistJobModelToJson(SpecialistJobModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'vehicle_id': instance.vehicleId,
      'addon_service_id': instance.addonServiceId,
      'specialist_id': instance.specialistId,
      'status': instance.status,
      'scheduled_date': instance.scheduledDate,
      'scheduled_slot_start': instance.scheduledSlotStart,
      'scheduled_slot_end': instance.scheduledSlotEnd,
      'supervisor_audit_status': instance.supervisorAuditStatus,
      'dispute_window_end': instance.disputeWindowEnd,
      'before_photos': instance.beforePhotos,
      'after_photos': instance.afterPhotos,
      'specialist_notes': instance.specialistNotes,
      'addon_service': instance.addonService,
      'vehicle': instance.vehicle,
      'user': instance.user,
    };

SpecialistAddonService _$SpecialistAddonServiceFromJson(
        Map<String, dynamic> json) =>
    SpecialistAddonService(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      estimatedDurationMinutes:
          (json['estimated_duration_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$SpecialistAddonServiceToJson(
        SpecialistAddonService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'estimated_duration_minutes': instance.estimatedDurationMinutes,
    };

SpecialistVehicle _$SpecialistVehicleFromJson(Map<String, dynamic> json) =>
    SpecialistVehicle(
      id: json['id'] as String,
      vehicleNumber: json['vehicle_number'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      sizeCategory: json['size_category'] as String,
      parkingLocationLat: (json['parking_location_lat'] as num?)?.toDouble(),
      parkingLocationLng: (json['parking_location_lng'] as num?)?.toDouble(),
      parkingNotes: json['parking_notes'] as String?,
      flatNo: json['flat_no'] as String?,
      building: json['building'] as String?,
      locality: json['locality'] as String?,
      landmark: json['landmark'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
    );

Map<String, dynamic> _$SpecialistVehicleToJson(SpecialistVehicle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle_number': instance.vehicleNumber,
      'brand': instance.brand,
      'model': instance.model,
      'size_category': instance.sizeCategory,
      'parking_location_lat': instance.parkingLocationLat,
      'parking_location_lng': instance.parkingLocationLng,
      'parking_notes': instance.parkingNotes,
      'flat_no': instance.flatNo,
      'building': instance.building,
      'locality': instance.locality,
      'landmark': instance.landmark,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
    };

SpecialistUser _$SpecialistUserFromJson(Map<String, dynamic> json) =>
    SpecialistUser(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SpecialistUserToJson(SpecialistUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
    };

SpecialistPhoto _$SpecialistPhotoFromJson(Map<String, dynamic> json) =>
    SpecialistPhoto(
      url: json['url'] as String,
      timestamp: json['timestamp'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$SpecialistPhotoToJson(SpecialistPhoto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'timestamp': instance.timestamp,
      'lat': instance.lat,
      'lng': instance.lng,
    };
