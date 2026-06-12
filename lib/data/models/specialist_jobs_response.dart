import 'package:json_annotation/json_annotation.dart';
import 'specialist_job_model.dart';

part 'specialist_jobs_response.g.dart';

@JsonSerializable()
class SpecialistJobsResponse {
  final bool success;
  final List<SpecialistJobModel> data;
  final String? timestamp;

  SpecialistJobsResponse({
    required this.success,
    required this.data,
    this.timestamp,
  });

  factory SpecialistJobsResponse.fromJson(Map<String, dynamic> json) =>
      _$SpecialistJobsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialistJobsResponseToJson(this);
}
