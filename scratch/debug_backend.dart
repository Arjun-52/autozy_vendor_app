import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

void main() async {
  final sessionFile = File('${Directory.systemTemp.path}/autozy_session.json');
  if (!sessionFile.existsSync()) {
    print('Error: autozy_session.json not found in temp directory.');
    return;
  }
  
  final sessionData = jsonDecode(sessionFile.readAsStringSync()) as Map<String, dynamic>;
  final token = sessionData['token'];
  print('Found session token: $token');
  
  final dio = Dio(BaseOptions(
    baseUrl: 'https://autozybackend.gyaanplant.co.in',
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  print('\n=== 1. Fetching Inspection 451735d8-d679-490b-8780-2e19a7af727a ===');
  try {
    final response = await dio.get('/api/v1/admin/inspections');
    final data = response.data['data'] as List;
    final item = data.firstWhere((e) => e['id'] == '451735d8-d679-490b-8780-2e19a7af727a', orElse: () => null);
    if (item != null) {
      print('Raw Inspection JSON:');
      print(JsonEncoder.withIndent('  ').convert(item));
    } else {
      print('Inspection 451735d8-d679-490b-8780-2e19a7af727a not found in active list. Fetching all:');
      for (var record in data) {
        print('- ID: ${record['id']}, booking_id: ${record['booking_id']}, vehicle: ${record['vehicle']}');
      }
    }
  } catch (e) {
    print('Error fetching inspection queue: $e');
  }

  print('\n=== 2. Fetching Service Records / Bookings ===');
  try {
    // Let's try to query the service records to see if we can find one for the same vehicle/booking
    final response = await dio.get('/api/v1/admin/service-records');
    final serviceRecords = response.data['data'] as List;
    print('Total Service Records: ${serviceRecords.length}');
    if (serviceRecords.isNotEmpty) {
      print('Keys in first service record: ${(serviceRecords.first as Map).keys.toList()}');
      print('First 3 Service Records details:');
      for (var i = 0; i < serviceRecords.length && i < 3; i++) {
        print(JsonEncoder.withIndent('  ').convert(serviceRecords[i]));
      }
    }
  } catch (e) {
    print('Error fetching service records: $e');
  }
}
