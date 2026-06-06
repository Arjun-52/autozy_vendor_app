import 'package:json_annotation/json_annotation.dart';
import 'pagination_meta.dart';

part 'admin_service_records_response.g.dart';

@JsonSerializable()
class AdminServiceRecordsResponse {
  final bool success;
  final List<dynamic> data;
  final PaginationMeta meta;
  final String? timestamp;

  AdminServiceRecordsResponse({
    required this.success,
    required this.data,
    required this.meta,
    this.timestamp,
  });

  factory AdminServiceRecordsResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminServiceRecordsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdminServiceRecordsResponseToJson(this);
}
