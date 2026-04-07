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
