// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_image_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadImageResponse _$UploadImageResponseFromJson(Map<String, dynamic> json) =>
    UploadImageResponse(
      success: json['success'] as bool,
      data: UploadImageData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$UploadImageResponseToJson(
        UploadImageResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

UploadImageData _$UploadImageDataFromJson(Map<String, dynamic> json) =>
    UploadImageData(
      url: json['url'] as String,
      key: json['key'] as String,
    );

Map<String, dynamic> _$UploadImageDataToJson(UploadImageData instance) =>
    <String, dynamic>{
      'url': instance.url,
      'key': instance.key,
    };
