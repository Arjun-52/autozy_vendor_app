import 'package:json_annotation/json_annotation.dart';
import 'attendance_model.dart';

part 'attendance_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AttendanceResponse {
  final List<AttendanceModel> items;
  final int total;
  final int page;
  final int limit;

  AttendanceResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceResponseToJson(this);
}