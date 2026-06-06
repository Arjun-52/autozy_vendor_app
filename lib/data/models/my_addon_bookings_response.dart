import 'package:json_annotation/json_annotation.dart';
import 'pagination_meta.dart';

part 'my_addon_bookings_response.g.dart';

@JsonSerializable()
class MyAddonBookingsResponse {
  final bool success;
  final List<dynamic> data;
  final PaginationMeta meta;
  final String? timestamp;

  MyAddonBookingsResponse({
    required this.success,
    required this.data,
    required this.meta,
    this.timestamp,
  });

  factory MyAddonBookingsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyAddonBookingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyAddonBookingsResponseToJson(this);
}
