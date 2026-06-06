import 'package:json_annotation/json_annotation.dart';

part 'send_otp_response.g.dart';

@JsonSerializable()
class SendOtpResponse {
  final bool success;
  final SendOtpData data;
  final String? timestamp;

  SendOtpResponse({
    required this.success,
    required this.data,
    this.timestamp,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpResponseToJson(this);
}

@JsonSerializable()
class SendOtpData {
  final String message;

  SendOtpData({
    required this.message,
  });

  factory SendOtpData.fromJson(Map<String, dynamic> json) =>
      _$SendOtpDataFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpDataToJson(this);
}
