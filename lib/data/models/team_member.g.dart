// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) => TeamMember(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      tower: json['tower'] as String,
      completed: (json['completed'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      status: json['member_status'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$TeamMemberToJson(TeamMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'tower': instance.tower,
      'completed': instance.completed,
      'total': instance.total,
      'member_status': instance.status,
      'phone': instance.phone,
    };
