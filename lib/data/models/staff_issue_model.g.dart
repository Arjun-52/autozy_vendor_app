// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_issue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffIssueRequest _$StaffIssueRequestFromJson(Map<String, dynamic> json) =>
    StaffIssueRequest(
      issueType: json['issue_type'] as String,
      description: json['description'] as String,
      urgent: json['urgent'] as bool,
    );

Map<String, dynamic> _$StaffIssueRequestToJson(StaffIssueRequest instance) =>
    <String, dynamic>{
      'issue_type': instance.issueType,
      'description': instance.description,
      'urgent': instance.urgent,
    };

StaffIssueResponse _$StaffIssueResponseFromJson(Map<String, dynamic> json) =>
    StaffIssueResponse(
      success: json['success'] as bool,
      data: StaffIssueData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$StaffIssueResponseToJson(StaffIssueResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

StaffIssueData _$StaffIssueDataFromJson(Map<String, dynamic> json) =>
    StaffIssueData(
      success: json['success'] as bool,
      notifiedCount: (json['notifiedCount'] as num).toInt(),
    );

Map<String, dynamic> _$StaffIssueDataToJson(StaffIssueData instance) =>
    <String, dynamic>{
      'success': instance.success,
      'notifiedCount': instance.notifiedCount,
    };
