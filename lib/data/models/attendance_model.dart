import 'package:json_annotation/json_annotation.dart';

part 'attendance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AttendanceModel {
  final String id;

  @JsonKey(name: 'staff_id')
  final String staffId;

  final String date;

  @JsonKey(name: 'check_in')
  final String? checkIn;

  @JsonKey(name: 'check_out')
  final String? checkOut;

  @JsonKey(name: 'gps_lat', fromJson: _parseDouble)
  final double? gpsLat;

  @JsonKey(name: 'gps_lng', fromJson: _parseDouble)
  final double? gpsLng;

  final String? status;

  final AttendanceStaff? staff;

  static double? _parseDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString());
  }

  AttendanceModel({
    required this.id,
    required this.staffId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.gpsLat,
    this.gpsLng,
    this.status,
    this.staff,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceModelToJson(this);
}

@JsonSerializable()
class AttendanceStaff {
  final String id;
  final String phone;
  final String name;
  final String role;

  @JsonKey(name: 'city_id')
  final String? cityId;

  @JsonKey(name: 'area_id')
  final String? areaId;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  AttendanceStaff({
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
    this.cityId,
    this.areaId,
    this.isActive,
  });

  factory AttendanceStaff.fromJson(Map<String, dynamic> json) =>
      _$AttendanceStaffFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceStaffToJson(this);
}