import 'package:json_annotation/json_annotation.dart';

part 'alert_model.g.dart';

@JsonSerializable()
class AlertModel {
  final String title;
  final String time;
  @JsonKey(name: 'alert_type')
  final String type; // idle / fraud / success

  // Existing constructor - KEEP UNCHANGED for backward compatibility
  AlertModel({required this.title, required this.time, required this.type});

  // New factory for JSON parsing
  factory AlertModel.fromJson(Map<String, dynamic> json) =>
      _$AlertModelFromJson(json);

  // New method for JSON serialization
  Map<String, dynamic> toJson() => _$AlertModelToJson(this);
}
