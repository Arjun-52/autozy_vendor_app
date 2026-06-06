import 'package:json_annotation/json_annotation.dart';
import 'inspection_model.dart';

part 'inspection_queue_response.g.dart';

@JsonSerializable()
class InspectionQueueResponse {
  final bool success;
  final List<InspectionModel> data;

  InspectionQueueResponse({
    required this.success,
    required this.data,
  });

  factory InspectionQueueResponse.fromJson(Map<String, dynamic> json) =>
      _$InspectionQueueResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionQueueResponseToJson(this);
}
