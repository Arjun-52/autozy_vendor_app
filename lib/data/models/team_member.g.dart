// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) => TeamMember(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      areaId: json['area_id'] as String? ?? '',
      tower: json['tower'] as String? ?? '',
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      status: json['member_status'] as String? ?? 'Offline',
    );

Map<String, dynamic> _$TeamMemberToJson(TeamMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'role': instance.role,
      'area_id': instance.areaId,
      'tower': instance.tower,
      'completed': instance.completed,
      'total': instance.total,
      'member_status': instance.status,
    };
