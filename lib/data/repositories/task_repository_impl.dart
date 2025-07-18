import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getAllTasks() async {
    final taskModels = await localDataSource.getAllTasks();
    return taskModels;
  }

  @override
  Future<Task> createTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dateTime: task.dateTime,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
    return await localDataSource.createTask(taskModel);
  }

  @override
  Future<Task> updateTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dateTime: task.dateTime,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
    return await localDataSource.updateTask(taskModel);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await localDataSource.deleteTask(taskId);
  }

  @override
  Future<Task?> getTaskById(String taskId) async {
    return await localDataSource.getTaskById(taskId);
  }
} 