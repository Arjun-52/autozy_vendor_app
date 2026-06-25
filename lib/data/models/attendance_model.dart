import 'package:json_annotation/json_annotation.dart';

part 'attendance_model.g.dart';

@JsonSerializable()
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

  static double? _parseDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString());
  }
  final String? status;

  AttendanceModel({
    required this.id,
    required this.staffId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.gpsLat,
    this.gpsLng,
    this.status,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceModelToJson(this);
}
