import 'package:json_annotation/json_annotation.dart';

part 'job_model.g.dart';

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

  // Existing constructor - KEEP UNCHANGED for backward compatibility
  JobModel({
    required this.vehicle,
    required this.name,
    required this.location,
    required this.phone,
    this.status = JobStatus.pending,
    this.beforeImage,
    this.capturedAt,
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
