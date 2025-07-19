import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dateTime,
    required super.createdAt,
    required super.updatedAt,
    super.priority,
    super.status,
    super.category,
    super.isCompleted,
  });

  factory TaskModel.create({
    required String title,
    required String description,
    required DateTime dateTime,
    TaskPriority priority = TaskPriority.medium,
    String? category,
  }) {
    final now = DateTime.now();
    // Add a small delay to ensure unique IDs
    return TaskModel(
      id: (now.millisecondsSinceEpoch + _idCounter++).toString(),
      title: title,
      description: description,
      dateTime: dateTime,
      createdAt: now,
      updatedAt: now,
      priority: priority,
      category: category,
    );
  }

  // Static counter to ensure unique IDs
  static int _idCounter = 0;

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString() == 'TaskPriority.${json['priority']}',
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.toString() == 'TaskStatus.${json['status']}',
        orElse: () => TaskStatus.pending,
      ),
      category: json['category'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  TaskModel copyWith({
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
    return TaskModel(
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
} 