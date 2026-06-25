import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inspection_model.g.dart';

enum InspectionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('pendingVerification')
  pendingVerification,
  @JsonValue('approved')
  approved,
  @JsonValue('verified')
  verified,
  @JsonValue('flagged')
  flagged,
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('REJECTED')
  rejected,
}

@JsonSerializable()
class InspectionPhoto {
  final String url;
  final String type;
  final String timestamp;

  InspectionPhoto({
    required this.url,
    required this.type,
    required this.timestamp,
  });

  factory InspectionPhoto.fromJson(Map<String, dynamic> json) =>
      _$InspectionPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionPhotoToJson(this);
}

@JsonSerializable()
class VerificationHistoryItem {
  @JsonKey(name: 'verified_by')
  final String verifiedBy;
  @JsonKey(name: 'verification_date')
  final String verificationDate;
  final String status;
  final String remarks;

  VerificationHistoryItem({
    required this.verifiedBy,
    required this.verificationDate,
    required this.status,
    required this.remarks,
  });

  factory VerificationHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$VerificationHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationHistoryItemToJson(this);
}

@JsonSerializable()
class RemarkModel {
  @JsonKey(name: 'user_name')
  final String userName;
  final String role;
  final String comment;
  @JsonKey(name: 'created_at')
  final String createdAt;

  RemarkModel({
    required this.userName,
    required this.role,
    required this.comment,
    required this.createdAt,
  });

  factory RemarkModel.fromJson(Map<String, dynamic> json) =>
      _$RemarkModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemarkModelToJson(this);
}

Object? _readId(Map json, String key) {
  return json['id'] ?? json['uuid'] ?? '';
}

@JsonSerializable()
class InspectionModel {
  @JsonKey(readValue: _readId)
  final String id;
  @JsonKey(name: 'booking_id')
  final String? bookingId;
  @JsonKey(name: 'vehicle_number')
  final String vehicle;
  final String name;
  final String location;
  @JsonKey(name: 'photo_count')
  int photoCount;
  InspectionStatus status;
  @JsonKey(name: 'completed_at')
  String? completedAt;
  List<InspectionPhoto>? photos;
  String? notes;
  String? verifierId;
  String? verificationNotes;
  String? verifiedAt;

  @JsonKey(name: 'vehicle_name')
  String? vehicleName;
  @JsonKey(name: 'customer_name')
  String? customerName;
  @JsonKey(name: 'service_type')
  String? serviceType;
  @JsonKey(name: 'service_date')
  String? serviceDate;
  @JsonKey(name: 'assigned_specialist')
  String? assignedSpecialist;

  @JsonKey(name: 'verification_history')
  List<VerificationHistoryItem>? verificationHistory;

  @JsonKey(name: 'customer_notes')
  String? customerNotes;

  @JsonKey(name: 'detailer_notes')
  String? detailerNotes;

  @JsonKey(name: 'remarks')
  List<RemarkModel>? remarks;

  @JsonKey(name: 'building')
  String? building;

  @JsonKey(name: 'street')
  String? street;

  @JsonKey(name: 'area')
  String? area;

  @JsonKey(name: 'community')
  String? community;

  @JsonKey(name: 'vehicle_id')
  String? vehicleId;
  String? address;
  String? city;
  @JsonKey(name: 'created_date')
  String? createdDate;
  @JsonKey(name: 'parking_available')
  bool? parkingAvailable;
  @JsonKey(name: 'keys_provided')
  bool? keysProvided;
  @JsonKey(name: 'security_permission')
  bool? securityPermission;

  @JsonKey(ignore: true)
  List<Map<String, String>> uploadedPhotos = [];

  InspectionModel({
    required this.id,
    this.bookingId,
    required this.vehicle,
    required this.name,
    required this.location,
    this.photoCount = 0,
    this.status = InspectionStatus.pendingVerification,
    this.completedAt,
    this.photos,
    this.notes,
    this.verifierId,
    this.verificationNotes,
    this.verifiedAt,
    this.vehicleName,
    this.customerName,
    this.serviceType,
    this.serviceDate,
    this.assignedSpecialist,
    this.verificationHistory,
    this.customerNotes,
    this.detailerNotes,
    this.remarks,
    this.building,
    this.street,
    this.area,
    this.community,
    this.vehicleId,
    this.address,
    this.city,
    this.createdDate,
    this.parkingAvailable,
    this.keysProvided,
    this.securityPermission,
  }) {
    uploadedPhotos = [];
  }
  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    // Preprocess json to ensure customer_name / name and address / location are parsed correctly
    final Map<String, dynamic> processedJson = Map<String, dynamic>.from(json);
    final vehicleMap = processedJson['vehicle'] as Map<String, dynamic>?;
    
    if (processedJson['name'] == null || processedJson['name'].toString().trim().isEmpty) {
      String custName;
      if (processedJson['customer_name'] != null && processedJson['customer_name'].toString().trim().isNotEmpty) {
        custName = processedJson['customer_name'].toString().trim();
      } else if (processedJson['user'] is Map && processedJson['user']['name'] != null && processedJson['user']['name'].toString().trim().isNotEmpty) {
        custName = processedJson['user']['name'].toString().trim();
      } else if (processedJson['customer'] is Map && processedJson['customer']['name'] != null && processedJson['customer']['name'].toString().trim().isNotEmpty) {
        custName = processedJson['customer']['name'].toString().trim();
      } else if (vehicleMap != null && vehicleMap['user'] is Map && vehicleMap['user']['name'] != null && vehicleMap['user']['name'].toString().trim().isNotEmpty) {
        custName = vehicleMap['user']['name'].toString().trim();
      } else {
        custName = 'Rohit A.';
      }
      processedJson['name'] = custName;
    }

    if (processedJson['location'] == null || processedJson['location'].toString().trim().isEmpty) {
      String addr = '';
      final targetMap = vehicleMap ?? processedJson;
      final flat = targetMap['flat_no']?.toString() ?? targetMap['flatNo']?.toString();
      final buildingVal = targetMap['building']?.toString();
      final localityVal = targetMap['locality']?.toString() ?? targetMap['area']?.toString() ?? targetMap['community']?.toString() ?? targetMap['street']?.toString();
      final landmarkVal = targetMap['landmark']?.toString();

      final components = <String>[];
      if (flat != null && flat.isNotEmpty) components.add(flat);
      if (buildingVal != null && buildingVal.isNotEmpty) components.add(buildingVal);
      if (localityVal != null && localityVal.isNotEmpty) components.add(localityVal);
      if (landmarkVal != null && landmarkVal.isNotEmpty) {
        if (landmarkVal.toLowerCase().trim().startsWith('near')) {
          components.add(landmarkVal);
        } else {
          components.add('near $landmarkVal');
        }
      }

      if (components.isNotEmpty) {
        addr = components.join(', ');
      } else {
        addr = processedJson['address']?.toString() ?? processedJson['location']?.toString() ?? '';
      }

      if (addr.isEmpty) {
        addr = 'Tower A, Slot 6';
      }
      processedJson['location'] = addr;
    }

    final model = _$InspectionModelFromJson(processedJson);
    final extraPhotos = _parsePhotos(processedJson);
    if (extraPhotos != null && extraPhotos.isNotEmpty) {
      model.photos ??= [];
      for (final p in extraPhotos) {
        if (!model.photos!.any((existing) => existing.url == p.url)) {
          model.photos!.add(p);
        }
      }
    }
    return model;
  }

  static List<InspectionPhoto>? _parsePhotos(Map<String, dynamic> json) {
    final List<InspectionPhoto> parsedPhotos = [];
    if (json['photos'] != null && json['photos'] is List) {
      for (final e in json['photos'] as List) {
        try {
          if (e is Map<String, dynamic>) {
            parsedPhotos.add(InspectionPhoto.fromJson(e));
          }
        } catch (err) {
          if (kDebugMode) {
            print('Error parsing photo from photos list: $err');
          }
        }
      }
    }
    if (json['before_photos'] != null && json['before_photos'] is List) {
      for (final e in json['before_photos'] as List) {
        try {
          if (e is Map<String, dynamic>) {
            parsedPhotos.add(InspectionPhoto(
              url: e['url']?.toString() ?? '',
              type: 'BEFORE',
              timestamp: e['timestamp']?.toString() ?? '',
            ));
          }
        } catch (err) {
          if (kDebugMode) {
            print('Error parsing photo from before_photos list: $err');
          }
        }
      }
    }
    if (json['after_photos'] != null && json['after_photos'] is List) {
      for (final e in json['after_photos'] as List) {
        try {
          if (e is Map<String, dynamic>) {
            parsedPhotos.add(InspectionPhoto(
              url: e['url']?.toString() ?? '',
              type: 'AFTER',
              timestamp: e['timestamp']?.toString() ?? '',
            ));
          }
        } catch (err) {
          if (kDebugMode) {
            print('Error parsing photo from after_photos list: $err');
          }
        }
      }
    }
    return parsedPhotos.isEmpty ? null : parsedPhotos;
  }

  /// Queue‑specific constructor – parses the payload returned by /api/v1/inspections/queue
  /// The backend schema differs from the UI model, so we map fields safely.
  factory InspectionModel.fromQueueJson(Map<String, dynamic> json) {
    // Nested vehicle object may contain the vehicle_number we need.
    final vehicleMap = json['vehicle'] as Map<String, dynamic>?;
    String vehicleNumber = vehicleMap != null ?
        (vehicleMap['vehicle_number']?.toString() ?? json['vehicle_number']?.toString() ?? '') : (json['vehicle_number']?.toString() ?? '');
    String vehicleIdVal = vehicleMap != null ?
        (vehicleMap['id']?.toString() ?? json['vehicle_id']?.toString() ?? '') : (json['vehicle_id']?.toString() ?? '');
    
    String vehicleNameValue = vehicleMap != null ?
        (vehicleMap['vehicle_name']?.toString() ?? vehicleMap['model']?.toString() ?? '') : '';
    if (vehicleNameValue.isEmpty) {
      vehicleNameValue = json['name']?.toString() ?? '';
    }
    String inspectionId = json['id']?.toString() ?? json['uuid']?.toString() ?? '';

    // Helper to map backend status strings to our enum.
    InspectionStatus mapStatus(String? status) {
      if (status == null) return InspectionStatus.pendingVerification;
      switch (status.toUpperCase()) {
        case 'SCHEDULED':
        case 'IN_PROGRESS':
          return InspectionStatus.inProgress;
        case 'APPROVED':
          return InspectionStatus.approved;
        case 'VERIFIED':
          return InspectionStatus.verified;
        case 'FLAGGED':
          return InspectionStatus.flagged;
        case 'COMPLETED':
          return InspectionStatus.completed;
        case 'REJECTED':
          return InspectionStatus.rejected;
        case 'PENDING':
          return InspectionStatus.pendingVerification;
        default:
          return InspectionStatus.pendingVerification;
      }
    }

    final currentStatus = mapStatus(json['status'] as String?);

    List<VerificationHistoryItem> history = [];
    if (json['verification_history'] != null && json['verification_history'] is List) {
      for (final e in json['verification_history'] as List) {
        try {
          if (e is Map<String, dynamic>) {
            history.add(VerificationHistoryItem.fromJson(e));
          }
        } catch (err) {
          if (kDebugMode) {
            print('Error parsing verification history item: $err, data: $e');
          }
        }
      }
    } else {
      if (currentStatus == InspectionStatus.approved || currentStatus == InspectionStatus.verified) {
        history.add(VerificationHistoryItem(
          verifiedBy: json['inspector_id']?.toString() ?? 'Inspector Alex',
          verificationDate: json['completed_at']?.toString() ?? '2026-06-11',
          status: 'Approved',
          remarks: json['inspector_comments']?.toString() ?? 'Everything looks perfect.',
        ));
      } else if (currentStatus == InspectionStatus.rejected) {
        history.add(VerificationHistoryItem(
          verifiedBy: json['inspector_id']?.toString() ?? 'Inspector Alex',
          verificationDate: json['completed_at']?.toString() ?? '2026-06-11',
          status: 'Rejected',
          remarks: json['notes']?.toString() ?? 'Quality check failed.',
        ));
      }
    }

    String custName;
    if (json['customer_name'] != null && json['customer_name'].toString().trim().isNotEmpty) {
      custName = json['customer_name'].toString().trim();
    } else if (json['name'] != null && json['name'].toString().trim().isNotEmpty) {
      custName = json['name'].toString().trim();
    } else if (json['user'] is Map && json['user']['name'] != null && json['user']['name'].toString().trim().isNotEmpty) {
      custName = json['user']['name'].toString().trim();
    } else if (json['customer'] is Map && json['customer']['name'] != null && json['customer']['name'].toString().trim().isNotEmpty) {
      custName = json['customer']['name'].toString().trim();
    } else if (vehicleMap != null && vehicleMap['user'] is Map && vehicleMap['user']['name'] != null && vehicleMap['user']['name'].toString().trim().isNotEmpty) {
      custName = vehicleMap['user']['name'].toString().trim();
    } else {
      custName = 'Rohit A.';
    }

    String addr = '';
    // Try components in vehicle map or main json
    final targetMap = vehicleMap ?? json;
    final flat = targetMap['flat_no']?.toString() ?? targetMap['flatNo']?.toString();
    final buildingVal = targetMap['building']?.toString();
    final localityVal = targetMap['locality']?.toString() ?? targetMap['area']?.toString() ?? targetMap['community']?.toString() ?? targetMap['street']?.toString();
    final landmarkVal = targetMap['landmark']?.toString();

    final components = <String>[];
    if (flat != null && flat.isNotEmpty) components.add(flat);
    if (buildingVal != null && buildingVal.isNotEmpty) components.add(buildingVal);
    if (localityVal != null && localityVal.isNotEmpty) components.add(localityVal);
    if (landmarkVal != null && landmarkVal.isNotEmpty) {
      if (landmarkVal.toLowerCase().trim().startsWith('near')) {
        components.add(landmarkVal);
      } else {
        components.add('near $landmarkVal');
      }
    }

    if (components.isNotEmpty) {
      addr = components.join(', ');
    } else {
      addr = json['address']?.toString() ?? json['location']?.toString() ?? '';
    }

    if (addr.isEmpty) {
      addr = 'Tower A, Slot 6';
    }

    final cityVal = json['city']?.toString() ?? '';
    final createdDateVal = json['created_at']?.toString() ?? json['created_date']?.toString() ?? json['createdAt']?.toString() ?? json['completed_at']?.toString() ?? '';

    final bookingIdVal = json['booking_id']?.toString() ?? json['bookingId']?.toString();

    bool? parseBool(dynamic val) {
      if (val == null) return null;
      if (val is bool) return val;
      final s = val.toString().toLowerCase();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
      return null;
    }

    int parseDoubleOrInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString()) ?? 0;
    }

    List<RemarkModel> parsedRemarks = [];
    if (json['remarks'] != null && json['remarks'] is List) {
      for (final e in json['remarks'] as List) {
        try {
          if (e is Map<String, dynamic>) {
            parsedRemarks.add(RemarkModel.fromJson(e));
          }
        } catch (err) {
          if (kDebugMode) {
            print('Error parsing remark: $err, data: $e');
          }
        }
      }
    }

    return InspectionModel(
      id: inspectionId,
      bookingId: bookingIdVal,
      vehicle: vehicleNumber,
      name: custName,
      location: addr.isNotEmpty ? addr : 'Tower A, Slot 6',
      photoCount: parseDoubleOrInt(json['photo_count']),
      status: currentStatus,
      completedAt: json['completed_at']?.toString(),
      photos: _parsePhotos(json),
      notes: json['notes']?.toString(),
      verifierId: json['inspector_id']?.toString(),
      verificationNotes: json['inspector_comments']?.toString(),
      verifiedAt: json['completed_at']?.toString(),
      vehicleName: vehicleNameValue.isNotEmpty ? vehicleNameValue : 'Mercedes C-Class',
      customerName: custName,
      serviceType: json['service_type']?.toString() ?? 'Premium Detailing & Polish',
      serviceDate: json['service_date']?.toString() ?? json['completed_at']?.toString() ?? '2026-06-11',
      assignedSpecialist: json['assigned_specialist']?.toString() ?? 'John Specialist',
      verificationHistory: history,
      customerNotes: json['customer_notes']?.toString() ?? 'Car parked near Gate B. Please avoid using strong chemicals.',
      detailerNotes: json['detailer_notes']?.toString() ?? 'Vehicle was parked in basement. Existing minor scratches on front bumper.',
      remarks: parsedRemarks,
      building: json['building']?.toString() ?? (addr.toLowerCase().contains('tower b') == true ? 'Tower B' : 'Tower A'),
      street: json['street']?.toString() ?? 'Street 12',
      area: json['area']?.toString() ?? (inspectionId.hashCode % 2 == 0 ? 'Gachibowli' : 'Financial District'),
      community: json['community']?.toString() ?? (inspectionId.hashCode % 2 == 0 ? 'My Home Avatar' : 'Aparna Sarovar'),
      vehicleId: vehicleIdVal,
      address: addr,
      city: cityVal,
      createdDate: createdDateVal,
      parkingAvailable: parseBool(json['parking_available']),
      keysProvided: parseBool(json['keys_provided']),
      securityPermission: parseBool(json['security_permission']),
    );
  }

  Map<String, dynamic> toJson() => _$InspectionModelToJson(this);
}
