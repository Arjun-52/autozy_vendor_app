import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationModel {
  final String id;
  
  @JsonKey(name: 'user_id')
  final String? userId;

  @JsonKey(name: 'staff_id')
  final String? staffId;

  final String type;
  final String title;
  final String body;

  final NotificationData? data;

  @JsonKey(name: 'is_read')
  final bool isRead;

  @JsonKey(name: 'created_at')
  final String createdAt;

  NotificationModel({
    required this.id,
    this.userId,
    this.staffId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}

@JsonSerializable()
class NotificationData {
  @JsonKey(name: 'broadcastBy')
  final String? broadcastBy;

  NotificationData({this.broadcastBy});

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}
