import 'package:json_annotation/json_annotation.dart';
import 'pagination_meta.dart';

part 'wash_history_response.g.dart';

@JsonSerializable()
class WashHistoryRecord {
  @JsonKey(name: 'vehicle_number')
  final String? vehicle;
  final String? status;
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @JsonKey(name: 'cna_status')
  final String? cnaStatus;
  @JsonKey(name: 'service_date')
  final String? serviceDate;

  WashHistoryRecord({
    this.vehicle,
    this.status,
    this.completedAt,
    this.cnaStatus,
    this.serviceDate,
  });

  factory WashHistoryRecord.fromJson(Map<String, dynamic> json) =>
      _$WashHistoryRecordFromJson(json);

  Map<String, dynamic> toJson() => _$WashHistoryRecordToJson(this);
}

@JsonSerializable()
class WashHistoryResponse {
  final bool success;
  final List<WashHistoryRecord> data;
  final PaginationMeta? meta;
  final String? timestamp;

  WashHistoryResponse({
    required this.success,
    required this.data,
    this.meta,
    this.timestamp,
  });

  factory WashHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$WashHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WashHistoryResponseToJson(this);
}
