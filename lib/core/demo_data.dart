import '../domain/entities/task.dart';
import '../data/models/task_model.dart';

class DemoData {
  static List<Task> getSampleTasks() {
    final now = DateTime.now();
    
    return [
      TaskModel.create(
        title: 'Team Meeting',
        description: 'Weekly team sync to discuss project progress and upcoming milestones',
        dateTime: now.add(const Duration(hours: 2)),
      ),
      TaskModel.create(
        title: 'Doctor Appointment',
        description: 'Annual health checkup with Dr. Smith',
        dateTime: now.add(const Duration(days: 1, hours: 10)),
      ),
      TaskModel.create(
        title: 'Grocery Shopping',
        description: 'Buy groceries for the week including fruits, vegetables, and household items',
        dateTime: now.add(const Duration(hours: 4)),
      ),
      TaskModel.create(
        title: 'Code Review',
        description: 'Review pull request for the new authentication feature',
        dateTime: now.add(const Duration(days: 2, hours: 14)),
      ),
      TaskModel.create(
        title: 'Gym Workout',
        description: 'Cardio and strength training session',
        dateTime: now.add(const Duration(hours: 6)),
      ),
    ];
  }
} 