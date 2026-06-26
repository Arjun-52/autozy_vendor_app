import 'package:json_annotation/json_annotation.dart';

part 'team_member.g.dart';

@JsonSerializable()
class TeamMember {
  final String id;
  final String name;
  final String phone;
  final String role;

@JsonKey(name: 'area_id')
final String areaId;

  // UI fields (filled later by other APIs)
  final String tower;
  final int completed;
  final int total;

  @JsonKey(name: 'member_status')
  final String status;

  TeamMember({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.areaId = '',
    this.tower = '',
    this.completed = 0,
    this.total = 0,
    this.status = 'Offline',
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);

  Map<String, dynamic> toJson() => _$TeamMemberToJson(this);
}