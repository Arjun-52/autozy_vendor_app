import 'package:flutter/material.dart';

class Task {
  final String vehicle;
  final String title;
  final List<String> steps;
  String? completedTime;
  bool isStarted;
  bool isCompleted;
  List<bool> stepCompleted;

  Task({
    required this.vehicle,
    required this.title,
    required this.completedTime,
    required this.steps,
    this.isStarted = false,
    this.isCompleted = false,
  }) : stepCompleted = List<bool>.filled(steps.length, false);
}

class SpecialistTasksViewModel extends ChangeNotifier {
  List<Task> tasks = [
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

  // Error state management
  String? _errorMessage;
  bool _showError = false;

  String? get errorMessage => _errorMessage;
  bool get showError => _showError;

  void startJob(int index) {
    tasks[index].isStarted = true;
    notifyListeners();
  }

  void completeJob(int i) {
    tasks[i].isCompleted = true;
    tasks[i].completedTime = "01:15:10";
    notifyListeners();
  }

  void toggleStep(int taskIndex, int stepIndex) {
    if (taskIndex < tasks.length && stepIndex < tasks[taskIndex].steps.length) {
      tasks[taskIndex].stepCompleted[stepIndex] =
          !tasks[taskIndex].stepCompleted[stepIndex];
      notifyListeners();
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
