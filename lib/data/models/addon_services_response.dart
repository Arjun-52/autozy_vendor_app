import 'package:json_annotation/json_annotation.dart';
import 'addon_service.dart';

part 'addon_services_response.g.dart';

@JsonSerializable()
class AddOnServicesResponse {
  final bool success;
  final List<AddOnService> data;
  final String? timestamp;

  AddOnServicesResponse({
    required this.success,
    required this.data,
    this.timestamp,
  });

  factory AddOnServicesResponse.fromJson(Map<String, dynamic> json) =>
      _$AddOnServicesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddOnServicesResponseToJson(this);
}
