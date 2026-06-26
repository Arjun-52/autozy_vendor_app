import 'package:autozy_vendor_app/data/models/task_model.dart';

class AssignedJobModel {
  final String id;
  final String userId;
  final String vehicleId;
  final String addonServiceId;
  final String specialistId;
  final String status;
  final String scheduledDate;
  final String scheduledSlotStart;
  final String scheduledSlotEnd;
  final String? supervisorAuditStatus;
  final String? disputeWindowEnd;
  final List<AssignedJobPhoto> beforePhotos;
  final List<AssignedJobPhoto> afterPhotos;
  final String? specialistNotes;
  final AssignedJobService addonService;
  final AssignedJobVehicle vehicle;
  final AssignedJobUser user;

  const AssignedJobModel({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.addonServiceId,
    required this.specialistId,
    required this.status,
    required this.scheduledDate,
    required this.scheduledSlotStart,
    required this.scheduledSlotEnd,
    required this.addonService,
    required this.vehicle,
    required this.user,
    this.supervisorAuditStatus,
    this.disputeWindowEnd,
    this.beforePhotos = const [],
    this.afterPhotos = const [],
    this.specialistNotes,
  });

  factory AssignedJobModel.fromJson(Map<String, dynamic> json) {
    return AssignedJobModel(
      id: _readString(json['id']),
      userId: _readString(json['user_id']),
      vehicleId: _readString(json['vehicle_id']),
      addonServiceId: _readString(json['addon_service_id']),
      specialistId: _readString(json['specialist_id']),
      status: _readString(json['status']).toUpperCase(),
      scheduledDate: _readString(json['scheduled_date']),
      scheduledSlotStart: _readString(json['scheduled_slot_start']),
      scheduledSlotEnd: _readString(json['scheduled_slot_end']),
      supervisorAuditStatus: _readNullableString(json['supervisor_audit_status']),
      disputeWindowEnd: _readNullableString(json['dispute_window_end']),
      beforePhotos: _readList(json['before_photos'])
          .map(AssignedJobPhoto.fromJson)
          .toList(),
      afterPhotos: _readList(json['after_photos'])
          .map(AssignedJobPhoto.fromJson)
          .toList(),
      specialistNotes: _readNullableString(json['specialist_notes']),
      addonService: AssignedJobService.fromJson(
        _readMap(json['addon_service']),
      ),
      vehicle: AssignedJobVehicle.fromJson(
        _readMap(json['vehicle']),
      ),
      user: AssignedJobUser.fromJson(
        _readMap(json['user']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vehicle_id': vehicleId,
      'addon_service_id': addonServiceId,
      'specialist_id': specialistId,
      'status': status,
      'scheduled_date': scheduledDate,
      'scheduled_slot_start': scheduledSlotStart,
      'scheduled_slot_end': scheduledSlotEnd,
      'supervisor_audit_status': supervisorAuditStatus,
      'dispute_window_end': disputeWindowEnd,
      'before_photos': beforePhotos.map((photo) => photo.toJson()).toList(),
      'after_photos': afterPhotos.map((photo) => photo.toJson()).toList(),
      'specialist_notes': specialistNotes,
      'addon_service': addonService.toJson(),
      'vehicle': vehicle.toJson(),
      'user': user.toJson(),
    };
  }

  bool get isCompleted => status == 'COMPLETED';
  bool get isInProgress => status == 'IN_PROGRESS' || status == 'STARTED';
  bool get isAccepted => status == 'ACCEPTED';
  bool get isAssigned => status == 'ASSIGNED';

  String get locationLabel {
    final locationParts = <String>[
      if (vehicle.flatNo != null && vehicle.flatNo!.isNotEmpty) vehicle.flatNo!,
      if (vehicle.building != null && vehicle.building!.isNotEmpty)
        vehicle.building!,
      if (vehicle.locality != null && vehicle.locality!.isNotEmpty)
        vehicle.locality!,
      if (vehicle.city != null && vehicle.city!.isNotEmpty) vehicle.city!,
    ];

    if (vehicle.parkingNotes != null && vehicle.parkingNotes!.isNotEmpty) {
      return vehicle.parkingNotes!;
    }

    if (locationParts.isEmpty) {
      return 'Location not available';
    }

    return locationParts.join(', ');
  }

  Task toTask() {
    return Task(
      vehicle: vehicle.vehicleNumber,
      title: addonService.name,
      completedTime: isCompleted ? scheduledSlotEnd : null,
      steps: [
        addonService.description,
        'Duration: ${addonService.estimatedDurationMinutes} mins',
        'Slot: $scheduledSlotStart - $scheduledSlotEnd',
      ],
      isStarted: isInProgress || isAssigned,
      isCompleted: isCompleted,
    );
  }

  static String _readString(dynamic value) {
    final stringValue = value?.toString().trim();
    return stringValue == null || stringValue.isEmpty ? '' : stringValue;
  }

  static String? _readNullableString(dynamic value) {
    final stringValue = value?.toString().trim();
    if (stringValue == null || stringValue.isEmpty || stringValue == 'null') {
      return null;
    }
    return stringValue;
  }

  static Map<String, dynamic> _readMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return <String, dynamic>{};
  }

  static List<Map<String, dynamic>> _readList(dynamic value) {
    if (value is List) {
      return value.whereType<Map<String, dynamic>>().toList();
    }
    return const <Map<String, dynamic>>[];
  }
}

class AssignedJobService {
  final String id;
  final String name;
  final String description;
  final int estimatedDurationMinutes;

  const AssignedJobService({
    required this.id,
    required this.name,
    required this.description,
    required this.estimatedDurationMinutes,
  });

  factory AssignedJobService.fromJson(Map<String, dynamic> json) {
    return AssignedJobService(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Service',
      description: json['description']?.toString() ?? '',
      estimatedDurationMinutes:
          (json['estimated_duration_minutes'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'estimated_duration_minutes': estimatedDurationMinutes,
    };
  }
}

class AssignedJobVehicle {
  final String id;
  final String vehicleNumber;
  final String brand;
  final String model;
  final String sizeCategory;
  final double? parkingLocationLat;
  final double? parkingLocationLng;
  final String? parkingNotes;
  final String? flatNo;
  final String? building;
  final String? locality;
  final String? landmark;
  final String? city;
  final String? state;
  final String? pincode;

  const AssignedJobVehicle({
    required this.id,
    required this.vehicleNumber,
    required this.brand,
    required this.model,
    required this.sizeCategory,
    this.parkingLocationLat,
    this.parkingLocationLng,
    this.parkingNotes,
    this.flatNo,
    this.building,
    this.locality,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
  });

  factory AssignedJobVehicle.fromJson(Map<String, dynamic> json) {
    return AssignedJobVehicle(
      id: json['id']?.toString() ?? '',
      vehicleNumber: json['vehicle_number']?.toString() ?? 'Unknown Vehicle',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      sizeCategory: json['size_category']?.toString() ?? '',
      parkingLocationLat: (json['parking_location_lat'] as num?)?.toDouble(),
      parkingLocationLng: (json['parking_location_lng'] as num?)?.toDouble(),
      parkingNotes: AssignedJobModel._readNullableString(json['parking_notes']),
      flatNo: AssignedJobModel._readNullableString(json['flat_no']),
      building: AssignedJobModel._readNullableString(json['building']),
      locality: AssignedJobModel._readNullableString(json['locality']),
      landmark: AssignedJobModel._readNullableString(json['landmark']),
      city: AssignedJobModel._readNullableString(json['city']),
      state: AssignedJobModel._readNullableString(json['state']),
      pincode: AssignedJobModel._readNullableString(json['pincode']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_number': vehicleNumber,
      'brand': brand,
      'model': model,
      'size_category': sizeCategory,
      'parking_location_lat': parkingLocationLat,
      'parking_location_lng': parkingLocationLng,
      'parking_notes': parkingNotes,
      'flat_no': flatNo,
      'building': building,
      'locality': locality,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
    };
  }
}

class AssignedJobUser {
  final String id;
  final String phone;
  final String name;

  const AssignedJobUser({
    required this.id,
    required this.phone,
    required this.name,
  });

  factory AssignedJobUser.fromJson(Map<String, dynamic> json) {
    return AssignedJobUser(
      id: json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Customer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
    };
  }
}

class AssignedJobPhoto {
  final String url;
  final String timestamp;
  final double? lat;
  final double? lng;

  const AssignedJobPhoto({
    required this.url,
    required this.timestamp,
    this.lat,
    this.lng,
  });

  factory AssignedJobPhoto.fromJson(Map<String, dynamic> json) {
    return AssignedJobPhoto(
      url: json['url']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ?? '',
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'timestamp': timestamp,
      'lat': lat,
      'lng': lng,
    };
  }
}
