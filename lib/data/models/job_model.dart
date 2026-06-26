import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_model.g.dart';

@JsonSerializable()
class JobRemarkModel {
  final String id;
  @JsonKey(name: 'job_id')
  final String? jobId;
  final String? reason;
  @JsonKey(name: 'additional_comment')
  final String? additionalComment;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'user_role')
  final String userRole;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'created_at')
  final String createdAt;

  JobRemarkModel({
    String? id,
    this.jobId,
    this.reason,
    this.additionalComment,
    this.createdBy = 'Detailer Mode',
    this.userRole = 'Detailer',
    this.userId,
    required this.createdAt,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  factory JobRemarkModel.fromJson(Map<String, dynamic> json) =>
      _$JobRemarkModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobRemarkModelToJson(this);
}

@JsonSerializable()
class JobModel {
  final String? id;
  @JsonKey(name: 'vehicle_number')
  final String vehicle;
  @JsonKey(name: 'customer_name')
  final String name;
  final String location;
  final String phone;
  final JobStatus status;

  @JsonKey(name: 'before_image')
  final String? beforeImage;
  @JsonKey(name: 'captured_at')
  final String? capturedAt;

  @JsonKey(name: 'after_image')
  final String? afterImage;
  @JsonKey(name: 'after_captured_at')
  final String? afterImageCapturedAt;

  @JsonKey(name: 'remarks')
  final List<JobRemarkModel>? remarks;
  @JsonKey(name: 'vehicle_image')
  final String? vehicleImage;

  // Existing constructor - KEEP UNCHANGED for backward compatibility
  JobModel({
    this.id,
    required this.vehicle,
    required this.name,
    required this.location,
    required this.phone,
    this.status = JobStatus.pending,
    this.beforeImage,
    this.capturedAt,
    this.afterImage,
    this.afterImageCapturedAt,
    this.remarks,
    this.vehicleImage,
  });

  // New factory for JSON parsing
  factory JobModel.fromJson(Map<String, dynamic> json) {
    final remarksJson = json['remarks'] as List<dynamic>?;

    return JobModel(
      id: json['id']?.toString(),
      vehicle: json['vehicle_number']?.toString() ??
          json['vehicle']?.toString() ??
          'Unknown Vehicle',
      name: json['customer_name']?.toString() ??
          json['name']?.toString() ??
          'Customer',
      location: json['location']?.toString() ?? 'No slot info',
      phone: json['phone']?.toString() ?? '',
      status: JobStatusMapper.fromBackend(json['status']),
      beforeImage: _readString(json['before_image']) ??
          _readString(json['before_photo_url']),
      capturedAt: _readString(json['captured_at']) ??
          _readString(json['before_photo_uploaded_at']),
      afterImage:
          _readString(json['after_image']) ?? _readString(json['after_photo_url']),
      afterImageCapturedAt: _readString(json['after_captured_at']) ??
          _readString(json['after_photo_uploaded_at']) ??
          _readString(json['completed_at']),
      remarks: remarksJson
          ?.whereType<Map<String, dynamic>>()
          .map(JobRemarkModel.fromJson)
          .toList(),
      vehicleImage: _readString(json['vehicle_image']),
    );
  }

  factory JobModel.fromDailyRouteRecord(Map<String, dynamic> json) {
    final vehicleJson = _readMap(json['vehicle']);
    final userJson = _readMap(vehicleJson?['user']);
    final photos = (json['photos'] as List<dynamic>? ?? const [])
        .map(_readMap)
        .whereType<Map<String, dynamic>>()
        .toList();
    final parsedStatus = JobStatusMapper.fromBackend(json['status']);

    String location = json['location']?.toString() ?? 'No slot info';
    if (vehicleJson != null) {
      final pillarNumber = vehicleJson['pillar_number']?.toString();
      final parkingNotes = vehicleJson['parking_notes']?.toString();
      if (pillarNumber != null && pillarNumber.isNotEmpty) {
        location = 'Pillar $pillarNumber';
      } else if (parkingNotes != null && parkingNotes.isNotEmpty) {
        location = parkingNotes;
      }
    }

    String? beforeImage =
        _readString(json['before_image']) ?? _readString(json['before_photo_url']);
    String? afterImage =
        _readString(json['after_image']) ?? _readString(json['after_photo_url']);

    if (beforeImage == null && photos.isNotEmpty) {
      beforeImage = _photoUrlFromMap(photos.first);
    }

    if (afterImage == null) {
      for (final photo in photos.reversed) {
        final photoUrl = _photoUrlFromMap(photo);
        if (photoUrl != null && photoUrl != beforeImage) {
          afterImage = photoUrl;
          break;
        }
      }
    }

    if (kDebugMode) {
      print(
        'Parsed model status: ${parsedStatus.logLabel} | Raw: ${json['status']} '
        '| Vehicle: ${vehicleJson?['vehicle_number']} | RecordID: ${json['id']}',
      );
    }

    return JobModel(
      id: json['id']?.toString(),
      vehicle: vehicleJson?['vehicle_number']?.toString() ?? 'Unknown Vehicle',
      name: userJson?['name']?.toString() ?? 'Customer',
      location: location,
      phone: userJson?['phone']?.toString() ?? '',
      status: parsedStatus,
      beforeImage: beforeImage,
      capturedAt: _readString(json['captured_at']) ??
          _readString(json['before_photo_uploaded_at']),
      afterImage: afterImage,
      afterImageCapturedAt: _readString(json['after_captured_at']) ??
          _readString(json['after_photo_uploaded_at']) ??
          _readString(json['completed_at']),
      remarks: (json['remarks'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(JobRemarkModel.fromJson)
          .toList(),
      vehicleImage: vehicleJson?['vehicle_image']?.toString(),
    );
  }

  // New method for JSON serialization
  Map<String, dynamic> toJson() => _$JobModelToJson(this);

  JobModel copyWith({
    String? id,
    String? vehicle,
    String? name,
    String? location,
    String? phone,
    JobStatus? status,
    String? beforeImage,
    String? capturedAt,
    String? afterImage,
    String? afterImageCapturedAt,
    List<JobRemarkModel>? remarks,
    String? vehicleImage,
  }) {
    return JobModel(
      id: id ?? this.id,
      vehicle: vehicle ?? this.vehicle,
      name: name ?? this.name,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      beforeImage: beforeImage ?? this.beforeImage,
      capturedAt: capturedAt ?? this.capturedAt,
      afterImage: afterImage ?? this.afterImage,
      afterImageCapturedAt:
          afterImageCapturedAt ?? this.afterImageCapturedAt,
      remarks: remarks ?? this.remarks,
      vehicleImage: vehicleImage ?? this.vehicleImage,
    );
  }

  // Existing getters - KEEP UNCHANGED
  bool get isCompleted => status == JobStatus.completed;
  bool get isCNA => status == JobStatus.cna;
  bool get isCleaning => status == JobStatus.cleaning;

  static Map<String, dynamic>? _readMap(dynamic value) {
    return value is Map<String, dynamic> ? value : null;
  }

  static String? _readString(dynamic value) {
    final stringValue = value?.toString();
    if (stringValue == null || stringValue.isEmpty || stringValue == 'null') {
      return null;
    }
    return stringValue;
  }

  static String? _photoUrlFromMap(Map<String, dynamic>? photo) {
    if (photo == null) return null;
    return _readString(photo['url']) ??
        _readString(photo['photo_url']) ??
        _readString(photo['image_url']);
  }
}

@JsonEnum()
enum JobStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('cleaning')
  cleaning,
  @JsonValue('completed')
  completed,
  @JsonValue('cna')
  cna,
}

class JobStatusMapper {
  static JobStatus fromBackend(dynamic rawStatus) {
    final normalizedStatus = rawStatus?.toString().trim().toUpperCase();

    switch (normalizedStatus) {
      case 'CLEANED':
      case 'COMPLETED':
      case 'DONE':
        return JobStatus.completed;
      case 'CLEANING':
      case 'IN_PROGRESS':
      case 'STARTED':
        return JobStatus.cleaning;
      case 'CNA':
      case 'MISSED':
        return JobStatus.cna;
      case 'PENDING':
      default:
        return JobStatus.pending;
    }
  }
}

extension JobStatusX on JobStatus {
  String get logLabel {
    switch (this) {
      case JobStatus.pending:
        return 'PENDING';
      case JobStatus.cleaning:
        return 'CLEANING';
      case JobStatus.completed:
        return 'CLEANED';
      case JobStatus.cna:
        return 'CNA';
    }
  }
}
