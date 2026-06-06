import '../../data/models/wash_history_response.dart';

abstract class IWashHistoryRepository {
  Future<WashHistoryResponse> getWashHistory({required int page, required int limit});
}
