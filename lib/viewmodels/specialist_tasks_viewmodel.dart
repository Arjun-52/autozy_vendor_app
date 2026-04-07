import 'package:flutter/material.dart';
import '../../core/interfaces/specialist_tasks_repository_interface.dart';
import '../../data/models/task_model.dart';

class SpecialistTasksViewModel extends ChangeNotifier {
  final ISpecialistTasksRepository _repository;

  SpecialistTasksViewModel(this._repository);

  List<Task> tasks = [];

  // Error state management
  String? _errorMessage;
  bool _showError = false;

  String? get errorMessage => _errorMessage;
  bool get showError => _showError;

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
