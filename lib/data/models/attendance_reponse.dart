import 'package:json_annotation/json_annotation.dart';
import 'attendance_model.dart';
import 'pagination_meta.dart';

part 'attendance_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AttendanceResponse {
  final bool success;

  final List<AttendanceModel> data;

  final PaginationMeta meta;

  final String? timestamp;

  AttendanceResponse({
    required this.success,
    required this.data,
    required this.meta,
    this.timestamp,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceResponseToJson(this);
}