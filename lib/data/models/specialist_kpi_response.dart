import 'package:json_annotation/json_annotation.dart';

part 'specialist_kpi_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SpecialistKpiResponse {
  final bool success;
  final SpecialistKpiData data;
  final String timestamp;

  SpecialistKpiResponse({
    required this.success,
    required this.data,
    required this.timestamp,
  });

  factory SpecialistKpiResponse.fromJson(Map<String, dynamic> json) =>
      _$SpecialistKpiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialistKpiResponseToJson(this);
}

@JsonSerializable()
class SpecialistKpiData {
  final int totalJobs;
  final int completedThisWeek;
  final num reworkPercent;
  final num averageRating;

  SpecialistKpiData({
    required this.totalJobs,
    required this.completedThisWeek,
    required this.reworkPercent,
    required this.averageRating,
  });

  factory SpecialistKpiData.fromJson(Map<String, dynamic> json) =>
      _$SpecialistKpiDataFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialistKpiDataToJson(this);
}
