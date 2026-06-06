import 'package:flutter/foundation.dart';
import '../../core/interfaces/wash_history_repository_interface.dart';
import '../../data/models/wash_history_response.dart';
import '../services/new_api_service.dart';

class WashHistoryRepository implements IWashHistoryRepository {
  final NewApiService _apiService;

  WashHistoryRepository(this._apiService);

  @override
  Future<WashHistoryResponse> getWashHistory({required int page, required int limit}) async {
    if (kDebugMode) {
      print('Wash History request start: page=$page, limit=$limit');
    }
    try {
      final response = await _apiService.getWashHistory(page, limit);
      if (kDebugMode) {
        print('API response received: $response');
      }

      if (response == null) {
        throw Exception("Null response received");
      }

      try {
        final parsedResponse = WashHistoryResponse.fromJson(response as Map<String, dynamic>);
        if (kDebugMode) {
          print('Parsing success');
          if (parsedResponse.meta != null) {
            print('Pagination data received: total=${parsedResponse.meta!.total}, page=${parsedResponse.meta!.page}, limit=${parsedResponse.meta!.limit}, totalPages=${parsedResponse.meta!.totalPages}');
          }
          if (parsedResponse.data.isEmpty) {
            print('Empty records response received');
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
        print('API request error: $e');
      }
      rethrow;
    }
  }
}
