import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high }
enum TaskStatus { pending, inProgress, completed, cancelled }

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TaskPriority priority;
  final TaskStatus status;
  final String? category;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.createdAt,
    required this.updatedAt,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.category,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    TaskPriority? priority,
    TaskStatus? status,
    String? category,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Task markAsCompleted() {
    return copyWith(
      isCompleted: true,
      status: TaskStatus.completed,
      updatedAt: DateTime.now(),
    );
  }

  Task markAsInProgress() {
    return copyWith(
      status: TaskStatus.inProgress,
      updatedAt: DateTime.now(),
    );
  }

  Task updatePriority(TaskPriority newPriority) {
    return copyWith(
      priority: newPriority,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dateTime,
        createdAt,
        updatedAt,
        priority,
        status,
        category,
        isCompleted,
      ];

  bool get isOverdue => DateTime.now().isAfter(dateTime) && !isCompleted;

  bool get isDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return today == taskDate;
  }

  bool get isDueTomorrow {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return tomorrow == taskDate;
  }

  String get priorityColor {
    switch (priority) {
      case TaskPriority.high:
        return '#FF4444';
      case TaskPriority.medium:
        return '#FF8800';
      case TaskPriority.low:
        return '#00C851';
    }
  }

  String get statusText {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }
} 