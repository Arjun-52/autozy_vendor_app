// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertModel _$AlertModelFromJson(Map<String, dynamic> json) => AlertModel(
      title: json['title'] as String,
      time: json['time'] as String,
      type: json['alert_type'] as String,
    );

Map<String, dynamic> _$AlertModelToJson(AlertModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'time': instance.time,
      'alert_type': instance.type,
    };
