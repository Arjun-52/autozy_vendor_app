// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpResponse _$SendOtpResponseFromJson(Map<String, dynamic> json) =>
    SendOtpResponse(
      success: json['success'] as bool,
      data: SendOtpData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$SendOtpResponseToJson(SendOtpResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

SendOtpData _$SendOtpDataFromJson(Map<String, dynamic> json) => SendOtpData(
      message: json['message'] as String,
    );

Map<String, dynamic> _$SendOtpDataToJson(SendOtpData instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
