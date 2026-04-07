import 'package:json_annotation/json_annotation.dart';

part 'team_member.g.dart';

@JsonSerializable()
class TeamMember {
  final String id;
  final String name;
  final String role;
  final String tower;
  final int completed;
  final int total;
  @JsonKey(name: 'member_status')
  final String status; // Active / Break / Offline

  // Existing constructor - KEEP UNCHANGED for backward compatibility
  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.tower,
    required this.completed,
    required this.total,
    required this.status,
  });

  // New factory for JSON parsing
  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);

  // New method for JSON serialization
  Map<String, dynamic> toJson() => _$TeamMemberToJson(this);
}
