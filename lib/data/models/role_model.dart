import 'package:json_annotation/json_annotation.dart';

part 'role_model.g.dart';

@JsonSerializable()
class RoleModel {
  final String title;
  final String subtitle;

  // Existing constructor - KEEP UNCHANGED for backward compatibility
  RoleModel({required this.title, required this.subtitle});

  // New factory for JSON parsing
  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  // New method for JSON serialization
  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
}
