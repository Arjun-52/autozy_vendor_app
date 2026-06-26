import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/interfaces/specialist_repository_interface.dart';
import '../models/assigned_job_model.dart';
import '../services/specialist_api_service.dart';

class SpecialistRepositoryException implements Exception {
  final String message;

  const SpecialistRepositoryException(this.message);

  @override
  String toString() => message;
}

class SpecialistRepository implements ISpecialistRepository {
  final SpecialistApiService _apiService;

  SpecialistRepository(this._apiService);

  @override
  Future<List<AssignedJobModel>> fetchAssignedJobs() async {
    try {
      final response = await _apiService.fetchAssignedJobs();
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw const SpecialistRepositoryException(
          'Unexpected response received from the server.',
        );
      }

      final success = data['success'] == true;
      if (!success) {
        throw const SpecialistRepositoryException(
          'Failed to fetch assigned jobs.',
        );
      }

      final jobs = (data['data'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(AssignedJobModel.fromJson)
          .toList();

      if (kDebugMode) {
        print('========== PARSED ==========');
        print('Total Jobs: ${jobs.length}');
        print('Job IDs: ${jobs.map((job) => job.id).toList()}');
        print('Statuses: ${jobs.map((job) => job.status).toList()}');
      }

      return jobs;
    } on DioError catch (error) {
      throw SpecialistRepositoryException(_mapDioError(error));
    } on SocketException {
      throw const SpecialistRepositoryException(
        'No internet connection. Please check your network and try again.',
      );
    } on SpecialistRepositoryException {
      rethrow;
    } catch (_) {
      throw const SpecialistRepositoryException(
        'Something went wrong while fetching assigned jobs.',
      );
    }
  }

  String _mapDioError(DioError error) {
    if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.sendTimeout ||
        error.type == DioErrorType.receiveTimeout) {
      return 'Request timed out. Please try again.';
    }

    if (error.type == DioErrorType.other ||
        error.error is SocketException) {
      return 'No internet connection. Please check your network and try again.';
    }

    final statusCode = error.response?.statusCode;
    switch (statusCode) {
      case 401:
        return 'Your session has expired. Please log in again.';
      case 403:
        return 'You do not have permission to view assigned jobs.';
      case 404:
        return 'Assigned jobs endpoint was not found.';
      case 500:
        return 'Server error. Please try again in a moment.';
      default:
        return 'Unable to fetch assigned jobs right now.';
    }
  }
}
