// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_addon_bookings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyAddonBookingsResponse _$MyAddonBookingsResponseFromJson(
        Map<String, dynamic> json) =>
    MyAddonBookingsResponse(
      success: json['success'] as bool,
      data: json['data'] as List<dynamic>,
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$MyAddonBookingsResponseToJson(
        MyAddonBookingsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'meta': instance.meta,
      'timestamp': instance.timestamp,
    };
