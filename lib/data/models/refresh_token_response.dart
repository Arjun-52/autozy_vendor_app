import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response.g.dart';

@JsonSerializable()
class RefreshTokenResponse {
  final bool success;
  final RefreshTokenData data;
  final String? timestamp;

  RefreshTokenResponse({
    required this.success,
    required this.data,
    this.timestamp,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}

@JsonSerializable()
class RefreshTokenData {
  final String accessToken;
  final String refreshToken;

  RefreshTokenData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenDataToJson(this);
}
