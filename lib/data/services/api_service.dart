import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Base API service for handling HTTP requests
/// Currently structured for future API integration
class ApiService {
  /// Placeholder for GET requests
  /// Replace with real implementation when API is ready
  Future<Map<String, dynamic>?> get(String endpoint) async {
    try {
      // Mock implementation - replace with real HTTP call
      if (kDebugMode) {
        print('API GET: $endpoint');
      }

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Return mock data for now
      return _getMockData(endpoint);
    } catch (e) {
      if (kDebugMode) {
        print('API GET Error: $e');
      }
      return null;
    }
  }

  /// Placeholder for POST requests
  /// Replace with real implementation when API is ready
  Future<Map<String, dynamic>?> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      // Mock implementation - replace with real HTTP call
      if (kDebugMode) {
        print('API POST: $endpoint');
        if (data != null) {
          print('Data: ${jsonEncode(data)}');
        }
      }

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Return mock success response
      return {
        'success': true,
        'message': 'Operation completed successfully',
        'data': data,
      };
    } catch (e) {
      if (kDebugMode) {
        print('API POST Error: $e');
      }
      return null;
    }
  }

  /// Mock data provider for development
  /// Remove this method when real API is implemented
  Map<String, dynamic> _getMockData(String endpoint) {
    switch (endpoint) {
      case '/jobs':
        return {
          'success': true,
          'data': [
            {
              'vehicle': 'TS 01 AB 1234',
              'name': 'Rahul S.',
              'location': 'Tower A, Slot 6',
              'phone': '+91 98765 43210',
              'status': 'pending',
            },
            {
              'vehicle': 'MH 03 CD 5678',
              'name': 'Priya N.',
              'location': 'Tower B, Slot 5',
              'phone': '+91 87654 32109',
              'status': 'pending',
            },
          ],
        };
      case '/inspections':
        return {
          'success': true,
          'data': [
            {
              'vehicle': 'MH 12 AB 3456',
              'name': 'John Doe',
              'location': 'Tower A, Slot 1',
              'status': 'pending',
              'photoCount': 0,
            },
          ],
        };
      case '/api/v1/admin/inspections?status=PENDING':
        return {
          'success': true,
          'data': [
            {
              'id': 'mock-uuid-1',
              'vehicle_id': 'vehicle-uuid-1',
              'vehicle': {
                'id': 'vehicle-uuid-1',
                'vehicle_number': 'MH 01 KL 9999',
              },
              'name': 'Rohit A',
              'customer_name': 'Rohit A',
              'location': 'Tower A, Slot 6',
              'address': 'Tower A, Slot 6',
              'city': 'Mumbai',
              'status': 'PENDING',
              'photo_count': 0,
              'created_at': '2026-06-12T12:00:00Z',
              'parking_available': true,
              'keys_provided': true,
              'security_permission': true,
            },
            {
              'id': 'mock-uuid-2',
              'vehicle_id': 'vehicle-uuid-2',
              'vehicle': {
                'id': 'vehicle-uuid-2',
                'vehicle_number': 'TS 09 XY 1234',
              },
              'name': 'Ankit S',
              'customer_name': 'Ankit S',
              'location': 'Tower B, Slot 3',
              'address': 'Tower B, Slot 3',
              'city': 'Hyderabad',
              'status': 'PENDING',
              'photo_count': 0,
              'created_at': '2026-06-12T11:30:00Z',
              'parking_available': true,
              'keys_provided': false,
              'security_permission': true,
            },
          ],
        };
      default:
        return {'success': true, 'data': []};
    }
  }
}
