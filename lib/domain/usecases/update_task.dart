import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Task> call(Task task) async {
    return await repository.updateTask(task);
  }
} 