import 'package:json_annotation/json_annotation.dart';

part 'reassign_detailer_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ReassignDetailerResponse {
  final bool success;
  final ReassignedRecord data;
  final String timestamp;

  ReassignDetailerResponse({
    required this.success,
    required this.data,
    required this.timestamp,
  });

  factory ReassignDetailerResponse.fromJson(Map<String, dynamic> json) =>
      _$ReassignDetailerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReassignDetailerResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ReassignedRecord {
  final String id;
  @JsonKey(name: 'subscription_id')
  final String subscriptionId;
  @JsonKey(name: 'vehicle_id')
  final String vehicleId;
  @JsonKey(name: 'detailer_id')
  final String detailerId;
  @JsonKey(name: 'service_date')
  final String serviceDate;
  @JsonKey(name: 'service_type')
  final String serviceType;
  final String status;
  @JsonKey(name: 'verification_status')
  final String verificationStatus;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final Map<String, dynamic>? vehicle;
  final Map<String, dynamic>? detailer;

  ReassignedRecord({
    required this.id,
    required this.subscriptionId,
    required this.vehicleId,
    required this.detailerId,
    required this.serviceDate,
    required this.serviceType,
    required this.status,
    required this.verificationStatus,
    required this.createdAt,
    this.vehicle,
    this.detailer,
  });

  factory ReassignedRecord.fromJson(Map<String, dynamic> json) =>
      _$ReassignedRecordFromJson(json);

  Map<String, dynamic> toJson() => _$ReassignedRecordToJson(this);
}
