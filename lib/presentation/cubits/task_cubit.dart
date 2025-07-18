import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/create_task.dart' as create_task;
import '../../domain/usecases/update_task.dart' as update_task;
import '../../domain/usecases/delete_task.dart' as delete_task;

// States
abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> tasks;

  TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class TaskCubit extends Cubit<TaskState> {
  final GetAllTasks getAllTasks;
  final create_task.CreateTask createTask;
  final update_task.UpdateTask updateTask;
  final delete_task.DeleteTask deleteTask;

  TaskCubit({
    required this.getAllTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial());

  Future<void> loadTasks() async {
    emit(TaskLoading());
    try {
      final tasks = await getAllTasks.call();
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> addTask(String title, String description, DateTime dateTime) async {
    try {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        dateTime: dateTime,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await createTask.call(task);
      
      // Reload tasks to show the new task in the list
      await loadTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> editTask(Task task) async {
    try {
      final updatedTask = task.copyWith(updatedAt: DateTime.now());
      await updateTask.call(updatedTask);
      
      // Reload tasks to show the updated task in the list
      await loadTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> removeTask(String taskId) async {
    try {
      await deleteTask.call(taskId);
      
      // Reload tasks to show the updated list
      await loadTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
} 