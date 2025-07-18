import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<TaskModel?> getTaskById(String taskId);
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
        description: 'Weekly team sync to discuss project progress',
        dateTime: DateTime.now().add(const Duration(hours: 2)),
      ),
      TaskModel.create(
        title: 'Doctor Appointment',
        description: 'Annual health checkup',
        dateTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
      ),
      TaskModel.create(
        title: 'Grocery Shopping',
        description: 'Buy groceries for the week',
        dateTime: DateTime.now().add(const Duration(hours: 4)),
      ),
    ];
    
    _tasks.addAll(demoTasks);
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    // Sort tasks chronologically by dateTime
    _tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return _tasks;
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    _tasks.add(task);
    return task;
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      return task;
    }
    throw Exception('Task not found');
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
  }

  @override
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }
} 