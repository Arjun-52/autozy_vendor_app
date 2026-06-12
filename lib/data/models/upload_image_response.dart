import 'package:json_annotation/json_annotation.dart';

part 'upload_image_response.g.dart';

@JsonSerializable()
class UploadImageResponse {
  final bool success;
  final UploadImageData data;
  final String? timestamp;

  UploadImageResponse({
    required this.success,
    required this.data,
    this.timestamp,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageResponseToJson(this);
}

@JsonSerializable()
class UploadImageData {
  final String url;
  final String key;

  UploadImageData({
    required this.url,
    required this.key,
  });

  factory UploadImageData.fromJson(Map<String, dynamic> json) =>
      _$UploadImageDataFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageDataToJson(this);
}
