import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response.g.dart';

@JsonSerializable()
class VerifyOtpResponse {
  final bool success;
  final VerifyOtpData data;
  final String? timestamp;

  VerifyOtpResponse({
    required this.success,
    required this.data,
    this.timestamp,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);
}

@JsonSerializable()
class VerifyOtpData {
  final String accessToken;
  final String refreshToken;
  final StaffData staff;

  VerifyOtpData({
    required this.accessToken,
    required this.refreshToken,
    required this.staff,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpDataFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpDataToJson(this);
}

@JsonSerializable()
class StaffData {
  final String id;
  final String phone;
  final String? name;
  final String? role;

  StaffData({
    required this.id,
    required this.phone,
    this.name,
    this.role,
  });

  factory StaffData.fromJson(Map<String, dynamic> json) =>
      _$StaffDataFromJson(json);

  Map<String, dynamic> toJson() => _$StaffDataToJson(this);
}
