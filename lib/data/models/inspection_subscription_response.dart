import 'package:json_annotation/json_annotation.dart';
import 'inspection_model.dart';

part 'inspection_subscription_response.g.dart';

@JsonSerializable()
class InspectionSubscriptionResponse {
  final bool success;
  final InspectionModel? data;
  final String timestamp;

  InspectionSubscriptionResponse({
    required this.success,
    this.data,
    required this.timestamp,
  });

  factory InspectionSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$InspectionSubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionSubscriptionResponseToJson(this);
}
