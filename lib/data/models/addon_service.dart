import 'package:json_annotation/json_annotation.dart';

part 'addon_service.g.dart';

@JsonSerializable()
class AddOnService {
  final String id;
  final String name;
  final String description;
  final int estimatedDuration;
  final String price;
  final String pricingId;

  AddOnService({
    required this.id,
    required this.name,
    required this.description,
    required this.estimatedDuration,
    required this.price,
    required this.pricingId,
  });

  factory AddOnService.fromJson(Map<String, dynamic> json) =>
      _$AddOnServiceFromJson(json);

  Map<String, dynamic> toJson() => _$AddOnServiceToJson(this);
}
