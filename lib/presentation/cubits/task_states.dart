import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskToggleLoading extends TaskState {
  final String taskId;
  
  const TaskToggleLoading(this.taskId);
  
  @override
  List<Object?> get props => [taskId];
}

class TaskCreateLoading extends TaskState {}

class TaskUpdateLoading extends TaskState {}

class TaskDeleteLoading extends TaskState {
  final String taskId;
  
  const TaskDeleteLoading(this.taskId);
  
  @override
  List<Object?> get props => [taskId];
}

class TasksLoaded extends TaskState {
  final List<Task> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskCreated extends TaskState {
  final Task task;

  const TaskCreated(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskUpdated extends TaskState {
  final Task task;

  const TaskUpdated(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskToggled extends TaskState {
  final Task task;
  final bool isCompleted;

  const TaskToggled(this.task, this.isCompleted);

  @override
  List<Object?> get props => [task, isCompleted];
}

class TaskDeleted extends TaskState {
  final String taskId;

  const TaskDeleted(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskToggleError extends TaskState {
  final String message;
  final String taskId;

  const TaskToggleError(this.message, this.taskId);

  @override
  List<Object?> get props => [message, taskId];
} 