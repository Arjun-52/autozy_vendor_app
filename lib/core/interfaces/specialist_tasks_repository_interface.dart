import '../../data/models/task_model.dart';

abstract class ISpecialistTasksRepository {
  Future<List<Task>> getTasks();
  Future<bool> startTask(int taskIndex);
  Future<bool> completeTask(int taskIndex);
  Future<bool> toggleStep(int taskIndex, int stepIndex);
}
