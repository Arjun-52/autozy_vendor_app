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
    );

Map<String, dynamic> _$SpecialistVehicleToJson(SpecialistVehicle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle_number': instance.vehicleNumber,
      'brand': instance.brand,
      'model': instance.model,
      'size_category': instance.sizeCategory,
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
