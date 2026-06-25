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
    };
