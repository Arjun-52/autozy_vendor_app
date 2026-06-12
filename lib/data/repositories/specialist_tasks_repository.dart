import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/interfaces/specialist_tasks_repository_interface.dart';
import '../../data/models/task_model.dart';
import '../../data/models/addon_service.dart';
import '../../data/models/addon_services_response.dart';
import '../../data/models/specialist_job_model.dart';
import '../../data/models/specialist_jobs_response.dart';
import '../services/new_api_service.dart';
import '../../data/models/pagination_meta.dart';

import '../../data/models/my_addon_bookings_response.dart';

class SpecialistTasksRepository implements ISpecialistTasksRepository {
  final NewApiService _apiService;

  SpecialistTasksRepository(this._apiService);

  @override
  Future<MyAddonBookingsResponse> getMyAddonBookings({
    required int page,
    required int limit,
  }) async {
    if (kDebugMode) {
      print('My Add-on Bookings request start');
      print('Page parameter: $page');
      print('Limit parameter: $limit');
    }
    try {
      final response = await _apiService.getMyAddonBookings(page, limit);
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        throw Exception("Null response received");
      }

      try {
        final parsedResponse = MyAddonBookingsResponse.fromJson(response as Map<String, dynamic>);
        if (kDebugMode) {
          print('Parsing success');
          print('Pagination data received: total=${parsedResponse.meta.total}, totalPages=${parsedResponse.meta.totalPages}');
        }

        if (parsedResponse.data.isEmpty) {
          if (kDebugMode) {
            print('Empty bookings response received');
          }
        }

        return parsedResponse;
      } catch (e) {
        if (kDebugMode) {
          print('Parsing failure: $e');
        }
        throw Exception("Failed to parse response: $e");
      }
    } catch (e) {
      if (kDebugMode) {
        print('API request error in getMyAddonBookings: $e');
      }
      if (e is DioError && e.response?.statusCode == 401) {
        if (kDebugMode) {
          print('Handling 401 gracefully inside repository');
        }
        return MyAddonBookingsResponse(
          success: false,
          data: [],
          meta: PaginationMeta(total: 0, page: page, limit: limit, totalPages: 0),
          timestamp: DateTime.now().toIso8601String(),
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<AddOnService>> getAddonServices() async {
    if (kDebugMode) {
      print('Add-on services request start');
    }
    try {
      final response = await _apiService.getAddonServices();
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        throw Exception("Null response received");
      }

      try {
        final parsedResponse = AddOnServicesResponse.fromJson(response as Map<String, dynamic>);
        if (kDebugMode) {
          print('Parsing success');
          print('Services count received: ${parsedResponse.data.length}');
        }
        return parsedResponse.data;
      } catch (e) {
        if (kDebugMode) {
          print('Parsing failure: $e');
        }
        throw Exception("Failed to parse response: $e");
      }
    } catch (e) {
      if (kDebugMode) {
        print('API request error: $e');
      }
      return <AddOnService>[];
    }
  }

  @override
  Future<List<SpecialistJobModel>> getSpecialistJobs({required String date}) async {
    if (kDebugMode) {
      print('Specialist Jobs request start');
      print('Date parameter being sent: $date');
    }
    try {
      final response = await _apiService.getSpecialistJobs(date);
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        throw Exception("Null response received");
      }

      try {
        final parsedResponse = SpecialistJobsResponse.fromJson(response as Map<String, dynamic>);
        if (kDebugMode) {
          print('Parsing success');
        }

        if (parsedResponse.data.isEmpty) {
          if (kDebugMode) {
            print('Empty jobs response received');
          }
        }

        return parsedResponse.data;
      } catch (e) {
        if (kDebugMode) {
          print('Parsing failure: $e');
        }
        throw Exception("Failed to parse response: $e");
      }
    } catch (e) {
      if (kDebugMode) {
        print('API request error: $e');
      }
      return <SpecialistJobModel>[];
    }
  }

  @override
  Future<List<Task>> getTasks() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 100));

    // Return exact same mock data as before
    return [
      Task(
        vehicle: "TS 01 AB 1234",
        title: "Interior Deep Clean",
        completedTime: null,
        steps: ["Vacuum interior", "Shampoo seats", "Dashboard polish"],
      ),
      Task(
        vehicle: "MH 01 QR 4444",
        title: "Engine Bay Wash",
        completedTime: null,
        steps: ["Degrease engine", "Pressure wash", "Detail hoses"],
      ),
      Task(
        vehicle: "MH 03 UV 4001",
        title: "Ceramic Coating",
        completedTime: null,
        steps: [
          "Surface prep",
          "Apply base coat",
          "Apply ceramic layer",
          "Cure time",
          "Final buff",
        ],
        isStarted: true,
      ),
    ];
  }

  @override
  Future<bool> startTask(int taskIndex) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<bool> completeTask(int taskIndex) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<bool> toggleStep(int taskIndex, int stepIndex) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }
}
