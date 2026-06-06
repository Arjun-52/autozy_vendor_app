// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpResponse _$VerifyOtpResponseFromJson(Map<String, dynamic> json) =>
    VerifyOtpResponse(
      success: json['success'] as bool,
      data: VerifyOtpData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$VerifyOtpResponseToJson(VerifyOtpResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

VerifyOtpData _$VerifyOtpDataFromJson(Map<String, dynamic> json) =>
    VerifyOtpData(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      staff: StaffData.fromJson(json['staff'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VerifyOtpDataToJson(VerifyOtpData instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'staff': instance.staff,
    };

StaffData _$StaffDataFromJson(Map<String, dynamic> json) => StaffData(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$StaffDataToJson(StaffData instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'role': instance.role,
    };
