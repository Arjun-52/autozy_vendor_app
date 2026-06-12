import 'package:json_annotation/json_annotation.dart';

part 'job_model.g.dart';

@JsonSerializable()
class JobRemarkModel {
  final String reason;
  @JsonKey(name: 'additional_comment')
  final String? additionalComment;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'created_at')
  final String createdAt;

  JobRemarkModel({
    required this.reason,
    this.additionalComment,
    this.createdBy = 'Detailer Mode',
    required this.createdAt,
  });

  factory JobRemarkModel.fromJson(Map<String, dynamic> json) =>
      _$JobRemarkModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobRemarkModelToJson(this);
}

@JsonSerializable()
class JobModel {
  @JsonKey(name: 'vehicle_number')
  final String vehicle;
  @JsonKey(name: 'customer_name')
  final String name;
  final String location;
  final String phone;
  final JobStatus status;

  @JsonKey(name: 'before_image')
  final String? beforeImage;
  @JsonKey(name: 'captured_at')
  final String? capturedAt;

  @JsonKey(name: 'after_image')
  final String? afterImage;
  @JsonKey(name: 'after_captured_at')
  final String? afterImageCapturedAt;

  @JsonKey(name: 'remarks')
  final List<JobRemarkModel>? remarks;

  // Existing constructor - KEEP UNCHANGED for backward compatibility
  JobModel({
    required this.vehicle,
    required this.name,
    required this.location,
    required this.phone,
    this.status = JobStatus.pending,
    this.beforeImage,
    this.capturedAt,
    this.afterImage,
    this.afterImageCapturedAt,
    this.remarks,
  });

  // New factory for JSON parsing
  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);

  // New method for JSON serialization
  Map<String, dynamic> toJson() => _$JobModelToJson(this);

  // Existing getters - KEEP UNCHANGED
  bool get isCompleted => status == JobStatus.completed;
  bool get isCNA => status == JobStatus.cna;
  bool get isCleaning => status == JobStatus.cleaning;
}

@JsonEnum()
enum JobStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('cleaning')
  cleaning,
  @JsonValue('completed')
  completed,
  @JsonValue('cna')
  cna,
}
