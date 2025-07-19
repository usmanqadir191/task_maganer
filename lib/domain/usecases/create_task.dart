import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTask {
  final TaskRepository repository;
  static int _idCounter = 0;

  CreateTask(this.repository);

  Future<Task> call(String title, String description, DateTime dateTime, TaskPriority priority, String? category) async {
    final now = DateTime.now();
    final task = Task(
      id: (now.millisecondsSinceEpoch + _idCounter++).toString(),
      title: title,
      description: description,
      dateTime: dateTime,
      createdAt: now,
      updatedAt: now,
      priority: priority,
      status: TaskStatus.pending,
      category: category,
      isCompleted: false,
    );
    
    return await repository.createTask(task);
  }
} 