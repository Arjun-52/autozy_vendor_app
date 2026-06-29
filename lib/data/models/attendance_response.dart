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

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>?;
    final totalVal = meta?['total'] ?? json['total'];
    final pageVal = meta?['page'] ?? json['page'];
    final limitVal = meta?['limit'] ?? json['limit'];

    final rawItems = json['data'] ?? json['items'] as List?;
    final itemsList = (rawItems as List?)
            ?.map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return AttendanceResponse(
      items: itemsList,
      total: totalVal is num ? totalVal.toInt() : 0,
      page: pageVal is num ? pageVal.toInt() : 1,
      limit: limitVal is num ? limitVal.toInt() : 10,
    );
  }

  Map<String, dynamic> toJson() => _$AttendanceResponseToJson(this);
}