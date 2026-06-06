import 'package:flutter/foundation.dart';
import '../../core/interfaces/specialist_tasks_repository_interface.dart';
import '../../data/models/task_model.dart';
import '../../data/models/addon_service.dart';
import '../../data/models/pagination_meta.dart';

import '../../data/models/specialist_job_model.dart';

class SpecialistTasksViewModel extends ChangeNotifier {
  final ISpecialistTasksRepository _repository;

  SpecialistTasksViewModel(this._repository);

  List<Task> tasks = [];
  List<SpecialistJobModel> _specialistJobs = [];
  List<SpecialistJobModel> get specialistJobs => _specialistJobs;

  bool _isLoadingJobs = false;
  bool get isLoadingJobs => _isLoadingJobs;

  List<AddOnService> _addonServices = [];
  List<AddOnService> get addonServices => _addonServices;

  bool _isLoadingAddonServices = false;
  bool get isLoadingAddonServices => _isLoadingAddonServices;

  List<dynamic> _addonBookings = [];
  List<dynamic> get addonBookings => _addonBookings;

  PaginationMeta? _bookingsMeta;
  PaginationMeta? get bookingsMeta => _bookingsMeta;

  bool _isLoadingBookings = false;
  bool get isLoadingBookings => _isLoadingBookings;

  Future<void> fetchAddonBookings({int page = 1, int limit = 20}) async {
    _isLoadingBookings = true;
    _errorMessage = null;
    _showError = false;
    notifyListeners();

    if (kDebugMode) {
      print('Controller fetch start');
    }

    try {
      final response = await _repository.getMyAddonBookings(page: page, limit: limit);
      _addonBookings = response.data;
      _bookingsMeta = response.meta;
      if (kDebugMode) {
        print('Controller fetch success');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Controller fetch failure: $e');
      }
      if (e.toString().contains('401') || e.toString().contains('Unauthorized') || e.toString().contains('unauthorized')) {
        _errorMessage = null;
        _showError = false;
      } else {
        _errorMessage = e.toString();
        _showError = true;
      }
    } finally {
      _isLoadingBookings = false;
      notifyListeners();
    }
  }

  String? _selectedPricingId;
  String? get selectedPricingId => _selectedPricingId;

  void selectService(String pricingId) {
    if (_selectedPricingId == pricingId) {
      _selectedPricingId = null;
    } else {
      _selectedPricingId = pricingId;
    }
    notifyListeners();
  }

  // Error state management
  String? _errorMessage;
  bool _showError = false;

  String? get errorMessage => _errorMessage;
  bool get showError => _showError;

  Future<void> fetchAddonServices() async {
    _isLoadingAddonServices = true;
    _errorMessage = null;
    _showError = false;
    notifyListeners();

    if (kDebugMode) {
      print('Controller fetch start');
    }

    try {
      _addonServices = await _repository.getAddonServices();
      if (kDebugMode) {
        print('Controller fetch success');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Controller fetch failure: $e');
      }
      if (e.toString().contains('401') || e.toString().contains('Unauthorized') || e.toString().contains('unauthorized')) {
        _errorMessage = null;
        _showError = false;
      } else {
        _errorMessage = e.toString();
        _showError = true;
      }
    } finally {
      _isLoadingAddonServices = false;
      notifyListeners();
    }
  }

  Future<void> fetchSpecialistJobs({String? date}) async {
    _isLoadingJobs = true;
    _errorMessage = null;
    _showError = false;
    notifyListeners();

    if (kDebugMode) {
      print('Controller fetch start');
    }

    final targetDate = date ?? DateTime.now().toString().split(' ')[0];

    try {
      _specialistJobs = await _repository.getSpecialistJobs(date: targetDate);
      if (kDebugMode) {
        print('Controller fetch success');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Controller fetch failure: $e');
      }
      if (e.toString().contains('401') || e.toString().contains('Unauthorized') || e.toString().contains('unauthorized')) {
        _errorMessage = null;
        _showError = false;
      } else {
        _errorMessage = e.toString();
        _showError = true;
      }
    } finally {
      _isLoadingJobs = false;
      notifyListeners();
    }
  }

  /// Load tasks from repository
  Future<void> loadTasks() async {
    try {
      tasks = await _repository.getTasks();
      notifyListeners();
    } catch (e) {
      // Keep fallback data if repository fails
      tasks = [
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
      notifyListeners();
    }
  }

  Future<void> startJob(int index) async {
    if (index < 0 || index >= tasks.length) return;

    try {
      final success = await _repository.startTask(index);
      if (success) {
        tasks[index].isStarted = true;
        notifyListeners();
      }
    } catch (e) {
      // Fallback to local update if repository fails
      tasks[index].isStarted = true;
      notifyListeners();
    }
  }

  Future<void> completeJob(int i) async {
    if (i < 0 || i >= tasks.length) return;

    try {
      final success = await _repository.completeTask(i);
      if (success) {
        tasks[i].isCompleted = true;
        tasks[i].completedTime = "01:15:10";
        notifyListeners();
      }
    } catch (e) {
      // Fallback to local update if repository fails
      tasks[i].isCompleted = true;
      tasks[i].completedTime = "01:15:10";
      notifyListeners();
    }
  }

  Future<void> toggleStep(int taskIndex, int stepIndex) async {
    if (taskIndex < tasks.length && stepIndex < tasks[taskIndex].steps.length) {
      try {
        final success = await _repository.toggleStep(taskIndex, stepIndex);
        if (success) {
          tasks[taskIndex].stepCompleted[stepIndex] =
              !tasks[taskIndex].stepCompleted[stepIndex];
          notifyListeners();
        }
      } catch (e) {
        // Fallback to local update if repository fails
        tasks[taskIndex].stepCompleted[stepIndex] =
            !tasks[taskIndex].stepCompleted[stepIndex];
        notifyListeners();
      }
    }
  }

  bool areAllStepsCompleted(int taskIndex) {
    if (taskIndex >= tasks.length) return false;
    return tasks[taskIndex].stepCompleted.every((completed) => completed);
  }

  void showErrorAlert() {
    _showErrorAlert();
  }

  void _showErrorAlert() {
    _errorMessage = "Complete all checklist items first";
    _showError = true;
    notifyListeners();

    // hide error after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _clearError();
    });
  }

  void _clearError() {
    _errorMessage = null;
    _showError = false;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
