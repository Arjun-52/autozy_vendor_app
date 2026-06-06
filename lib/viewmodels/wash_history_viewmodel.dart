import 'package:flutter/foundation.dart';
import '../core/interfaces/wash_history_repository_interface.dart';
import '../data/models/wash_history_response.dart';

class WashHistoryViewModel extends ChangeNotifier {
  final IWashHistoryRepository _repository;

  WashHistoryViewModel(this._repository);

  List<WashHistoryRecord> _records = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  List<WashHistoryRecord> get records => _records;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  Future<void> fetchHistory({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _totalPages = 1;
      _hasMore = true;
      _records = [];
      _error = null;
    }

    if (!_hasMore || _isLoading) return;

    if (kDebugMode) {
      print('Controller fetch start: page=$_currentPage');
    }
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.getWashHistory(page: _currentPage, limit: 10);
      _records.addAll(response.data);
      
      if (response.meta != null) {
        _totalPages = response.meta!.totalPages;
        _currentPage = response.meta!.page + 1;
        _hasMore = response.meta!.page < response.meta!.totalPages;
      } else {
        _hasMore = false; // No pagination meta means no more pages
      }

      if (kDebugMode) {
        print('Controller fetch success: loaded ${response.data.length} records');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Controller fetch failure: $e');
      }
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
