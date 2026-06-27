import 'package:json_annotation/json_annotation.dart';
import 'notification_model.dart';
import 'pagination_meta.dart';

part 'notification_response.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationResponse {
  final bool success;
  final List<NotificationModel> data;
  final PaginationMeta meta;
  final String timestamp;

  NotificationResponse({
    required this.success,
    required this.data,
    required this.meta,
    required this.timestamp,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}
