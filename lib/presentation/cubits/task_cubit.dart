import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/create_task.dart' as create_task;
import '../../domain/usecases/update_task.dart' as update_task;
import '../../domain/usecases/delete_task.dart' as delete_task;
import 'task_states.dart';

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

  Future<void> addTask(String title, String description, DateTime dateTime, TaskPriority priority, String? category) async {
    emit(TaskCreateLoading());
    try {
      final task = await createTask.call(title, description, dateTime, priority, category);
      emit(TaskCreated(task));
      await loadTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> editTask(Task task) async {
    emit(TaskUpdateLoading());
    try {
      final updatedTask = await updateTask.call(task);
      emit(TaskUpdated(updatedTask));
      await loadTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> removeTask(String taskId) async {
    emit(TaskDeleteLoading(taskId));
    try {
      await deleteTask.call(taskId);
      emit(TaskDeleted(taskId));
      await loadTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final currentState = state;
      if (currentState is TasksLoaded) {
        final task = currentState.tasks.firstWhere((t) => t.id == taskId);
        
        final updatedTask = task.isCompleted 
            ? task.copyWith(isCompleted: false, status: TaskStatus.pending, updatedAt: DateTime.now())
            : task.markAsCompleted();
        
        final savedTask = await updateTask.call(updatedTask);
        
        final updatedTasks = currentState.tasks.map((t) => t.id == taskId ? savedTask : t).toList();
        emit(TasksLoaded(updatedTasks));
      } else {
        emit(TaskToggleError('Invalid state for toggle operation', taskId));
      }
    } catch (e) {
      emit(TaskToggleError(e.toString(), taskId));
    }
  }
} 