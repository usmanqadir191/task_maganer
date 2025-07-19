import '../../domain/entities/task.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<TaskModel?> getTaskById(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final List<TaskModel> _tasks = [];

  TaskLocalDataSourceImpl() {
    // Add some demo data
    _addDemoData();
  }

  void _addDemoData() {
    final demoTasks = [
      TaskModel.create(
        title: 'Team Meeting',
        description: 'Weekly team sync to discuss project progress and upcoming milestones',
        dateTime: DateTime.now().add(const Duration(hours: 2)),
        priority: TaskPriority.high,
        category: 'Work',
      ),
      TaskModel.create(
        title: 'Doctor Appointment',
        description: 'Annual health checkup and blood work',
        dateTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
        priority: TaskPriority.medium,
        category: 'Health',
      ),
      TaskModel.create(
        title: 'Grocery Shopping',
        description: 'Buy groceries for the week including fruits, vegetables, and household items',
        dateTime: DateTime.now().add(const Duration(hours: 4)),
        priority: TaskPriority.low,
        category: 'Personal',
      ),
      TaskModel.create(
        title: 'Gym Workout',
        description: 'Cardio and strength training session',
        dateTime: DateTime.now().add(const Duration(hours: 6)),
        priority: TaskPriority.medium,
        category: 'Fitness',
      ),
      TaskModel.create(
        title: 'Project Deadline',
        description: 'Submit final project documentation and presentation',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        priority: TaskPriority.high,
        category: 'Work',
      ),
    ];

    _tasks.addAll(demoTasks);
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Return sorted by date/time
    final sortedTasks = List<TaskModel>.from(_tasks);
    sortedTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return sortedTasks;
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    _tasks.add(task);
    return task;
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      return task;
    }
    throw Exception('Task not found');
  }

  @override
  Future<void> deleteTask(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    _tasks.removeWhere((task) => task.id == id);
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
} 