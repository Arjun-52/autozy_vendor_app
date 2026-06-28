import 'package:json_annotation/json_annotation.dart';

part 'staff_issue_model.g.dart';

@JsonSerializable()
class StaffIssueRequest {
  @JsonKey(name: 'issue_type')
  final String issueType;
  final String description;
  final bool urgent;

  StaffIssueRequest({
    required this.issueType,
    required this.description,
    required this.urgent,
  });

  factory StaffIssueRequest.fromJson(Map<String, dynamic> json) =>
      _$StaffIssueRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StaffIssueRequestToJson(this);
}

@JsonSerializable()
class StaffIssueResponse {
  final bool success;
  final StaffIssueData data;
  final String timestamp;

  StaffIssueResponse({
    required this.success,
    required this.data,
    required this.timestamp,
  });

  factory StaffIssueResponse.fromJson(Map<String, dynamic> json) =>
      _$StaffIssueResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StaffIssueResponseToJson(this);
}

@JsonSerializable()
class StaffIssueData {
  final bool success;
  @JsonKey(name: 'notifiedCount')
  final int notifiedCount;

  StaffIssueData({
    required this.success,
    required this.notifiedCount,
  });

  factory StaffIssueData.fromJson(Map<String, dynamic> json) =>
      _$StaffIssueDataFromJson(json);

  Map<String, dynamic> toJson() => _$StaffIssueDataToJson(this);
}
