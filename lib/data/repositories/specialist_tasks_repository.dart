import '../../core/interfaces/specialist_tasks_repository_interface.dart';
import '../../data/models/task_model.dart';

class SpecialistTasksRepository implements ISpecialistTasksRepository {
  @override
  Future<List<Task>> getTasks() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 100));

    // Return exact same mock data as before
    return [
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
  }

  @override
  Future<bool> startTask(int taskIndex) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<bool> completeTask(int taskIndex) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<bool> toggleStep(int taskIndex, int stepIndex) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }
}
