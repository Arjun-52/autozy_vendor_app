import '../core/base/base_viewmodel.dart';
import '../core/interfaces/inspector_repository_interface.dart';
import '../data/models/inspection_model.dart';

class InspectorViewModel extends BaseViewModel {
  final IInspectorRepository _repository;

  InspectorViewModel(this._repository);

  List<InspectionModel> _inspections = [];

  List<InspectionModel> get inspections => _inspections;

  Future<void> loadInspections() async {
    await executeOperation(() async {
      _inspections = await _repository.getInspections();
    }, onError: "Failed to load inspections");
  }

  void approveInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.approveInspection(_inspections[index].vehicle).then((_) {
      _inspections[index].status = InspectionStatus.approved;
      notifyListeners();
    });
  }

  void flagInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.flagInspection(_inspections[index].vehicle).then((_) {
      _inspections[index].status = InspectionStatus.flagged;
      notifyListeners();
    });
  }

  void addPhoto(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.addPhoto(_inspections[index].vehicle).then((_) {
      _inspections[index].photoCount++;
      notifyListeners();
    });
  }

  void resetInspection(int index) {
    if (index < 0 || index >= _inspections.length) return;

    // Use repository for API call in future
    _repository.resetInspection(_inspections[index].vehicle).then((_) {
      _inspections[index].status = InspectionStatus.pending;
      notifyListeners();
    });
  }

  int get approvedCount =>
      _inspections.where((e) => e.status == InspectionStatus.approved).length;

  int get pendingCount =>
      _inspections.where((e) => e.status == InspectionStatus.pending).length;

  int get flaggedCount =>
      _inspections.where((e) => e.status == InspectionStatus.flagged).length;
}
