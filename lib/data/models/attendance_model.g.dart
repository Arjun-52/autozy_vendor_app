// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    AttendanceModel(
      id: json['id'] as String,
      staffId: json['staff_id'] as String,
      date: json['date'] as String,
      checkIn: json['check_in'] as String?,
      checkOut: json['check_out'] as String?,
      gpsLat: AttendanceModel._parseDouble(json['gps_lat']),
      gpsLng: AttendanceModel._parseDouble(json['gps_lng']),
      status: json['status'] as String?,
      staff: json['staff'] == null
          ? null
          : AttendanceStaff.fromJson(json['staff'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AttendanceModelToJson(AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'staff_id': instance.staffId,
      'date': instance.date,
      'check_in': instance.checkIn,
      'check_out': instance.checkOut,
      'gps_lat': instance.gpsLat,
      'gps_lng': instance.gpsLng,
      'status': instance.status,
      'staff': instance.staff?.toJson(),
    };

AttendanceStaff _$AttendanceStaffFromJson(Map<String, dynamic> json) =>
    AttendanceStaff(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      cityId: json['city_id'] as String?,
      areaId: json['area_id'] as String?,
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$AttendanceStaffToJson(AttendanceStaff instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'role': instance.role,
      'city_id': instance.cityId,
      'area_id': instance.areaId,
      'is_active': instance.isActive,
    };
