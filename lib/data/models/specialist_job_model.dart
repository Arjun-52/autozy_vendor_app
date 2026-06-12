import 'package:json_annotation/json_annotation.dart';
import 'task_model.dart';

part 'specialist_job_model.g.dart';

@JsonSerializable()
class SpecialistJobModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'vehicle_id')
  final String vehicleId;
  @JsonKey(name: 'addon_service_id')
  final String addonServiceId;
  @JsonKey(name: 'specialist_id')
  final String specialistId;
  final String status;
  @JsonKey(name: 'scheduled_date')
  final String scheduledDate;
  @JsonKey(name: 'scheduled_slot_start')
  final String scheduledSlotStart;
  @JsonKey(name: 'scheduled_slot_end')
  final String scheduledSlotEnd;

  @JsonKey(name: 'addon_service')
  final SpecialistAddonService addonService;
  final SpecialistVehicle vehicle;
  final SpecialistUser user;

  SpecialistJobModel({
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
  });

  Task toTask() {
    return Task(
      vehicle: vehicle.vehicleNumber,
      title: addonService.name,
      completedTime: status == "COMPLETED" ? scheduledSlotEnd : null,
      steps: [
        addonService.description,
        "Duration: ${addonService.estimatedDurationMinutes} mins",
        "Slot: $scheduledSlotStart - $scheduledSlotEnd"
      ],
      isStarted: status == "IN_PROGRESS" || status == "STARTED" || status == "ASSIGNED",
      isCompleted: status == "COMPLETED",
    );
  }

  factory SpecialistJobModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialistJobModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialistJobModelToJson(this);
}

@JsonSerializable()
class SpecialistAddonService {
  final String id;
  final String name;
  final String description;
  @JsonKey(name: 'estimated_duration_minutes')
  final int estimatedDurationMinutes;

  SpecialistAddonService({
    required this.id,
    required this.name,
    required this.description,
    required this.estimatedDurationMinutes,
  });

  factory SpecialistAddonService.fromJson(Map<String, dynamic> json) =>
      _$SpecialistAddonServiceFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialistAddonServiceToJson(this);
}

@JsonSerializable()
class SpecialistVehicle {
  final String id;
  @JsonKey(name: 'vehicle_number')
  final String vehicleNumber;
  final String brand;
  final String model;
  @JsonKey(name: 'size_category')
  final String sizeCategory;

  SpecialistVehicle({
    required this.id,
    required this.vehicleNumber,
    required this.brand,
    required this.model,
    required this.sizeCategory,
  });

  factory SpecialistVehicle.fromJson(Map<String, dynamic> json) =>
      _$SpecialistVehicleFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialistVehicleToJson(this);
}

@JsonSerializable()
class SpecialistUser {
  final String id;
  final String phone;
  final String name;

  SpecialistUser({
    required this.id,
    required this.phone,
    required this.name,
  });

  factory SpecialistUser.fromJson(Map<String, dynamic> json) =>
      _$SpecialistUserFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialistUserToJson(this);
}
