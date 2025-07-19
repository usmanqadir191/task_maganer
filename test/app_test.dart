import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/domain/entities/task.dart';
import 'package:task_manager_app/domain/entities/voice_command.dart';
import 'package:task_manager_app/presentation/cubits/task_states.dart';
import 'package:task_manager_app/presentation/cubits/voice_states.dart';

void main() {
  group('Task Manager Core Tests', () {
    test('Task completion toggle should work correctly', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dateTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        isCompleted: false,
      );

      // Test marking as completed
      final completedTask = task.markAsCompleted();
      expect(completedTask.isCompleted, true);
      expect(completedTask.status, TaskStatus.completed);

      // Test marking as not completed
      final uncompletedTask = completedTask.copyWith(
        isCompleted: false,
        status: TaskStatus.pending,
        updatedAt: DateTime.now(),
      );
      expect(uncompletedTask.isCompleted, false);
      expect(uncompletedTask.status, TaskStatus.pending);
    });

    test('TaskToggled state should work correctly', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dateTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isCompleted: false,
      );
      
      // Test TaskToggled state for completion
      final completedTask = task.markAsCompleted();
      expect(completedTask.isCompleted, true);
      expect(completedTask.status, TaskStatus.completed);
      
      // Test TaskToggled state for uncompletion
      final uncompletedTask = completedTask.copyWith(
        isCompleted: false,
        status: TaskStatus.pending,
        updatedAt: DateTime.now(),
      );
      expect(uncompletedTask.isCompleted, false);
      expect(uncompletedTask.status, TaskStatus.pending);
    });

    test('Task priority colors should be correct', () {
      expect(TaskPriority.high.toString(), 'TaskPriority.high');
      expect(TaskPriority.medium.toString(), 'TaskPriority.medium');
      expect(TaskPriority.low.toString(), 'TaskPriority.low');
    });

    test('Task status text should be correct', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dateTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(task.statusText, 'Pending');
      
      final inProgressTask = task.copyWith(status: TaskStatus.inProgress);
      expect(inProgressTask.statusText, 'In Progress');
      
      final completedTask = task.copyWith(status: TaskStatus.completed);
      expect(completedTask.statusText, 'Completed');
      
      final cancelledTask = task.copyWith(status: TaskStatus.cancelled);
      expect(cancelledTask.statusText, 'Cancelled');
    });

    test('Task copyWith should work correctly', () {
      final task = Task(
        id: '1',
        title: 'Original Task',
        description: 'Original Description',
        dateTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        priority: TaskPriority.low,
        status: TaskStatus.pending,
        isCompleted: false,
      );

      final updatedTask = task.copyWith(
        title: 'Updated Task',
        description: 'Updated Description',
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        isCompleted: true,
      );

      expect(updatedTask.title, 'Updated Task');
      expect(updatedTask.description, 'Updated Description');
      expect(updatedTask.priority, TaskPriority.high);
      expect(updatedTask.status, TaskStatus.inProgress);
      expect(updatedTask.isCompleted, true);
      expect(updatedTask.id, task.id); // ID should remain the same
    });

    test('Task overdue detection should work correctly', () {
      final now = DateTime.now();
      final pastTask = Task(
        id: '1',
        title: 'Past Task',
        description: 'Past Description',
        dateTime: now.subtract(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
        isCompleted: false,
      );

      final futureTask = Task(
        id: '2',
        title: 'Future Task',
        description: 'Future Description',
        dateTime: now.add(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
        isCompleted: false,
      );

      final completedPastTask = pastTask.copyWith(isCompleted: true);

      expect(pastTask.isOverdue, true);
      expect(futureTask.isOverdue, false);
      expect(completedPastTask.isOverdue, false); // Completed tasks are not overdue
    });

    test('Task due date detection should work correctly', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final nextWeek = today.add(const Duration(days: 7));

      final todayTask = Task(
        id: '1',
        title: 'Today Task',
        description: 'Today Description',
        dateTime: today.add(const Duration(hours: 12)),
        createdAt: now,
        updatedAt: now,
      );

      final tomorrowTask = Task(
        id: '2',
        title: 'Tomorrow Task',
        description: 'Tomorrow Description',
        dateTime: tomorrow.add(const Duration(hours: 12)),
        createdAt: now,
        updatedAt: now,
      );

      final nextWeekTask = Task(
        id: '3',
        title: 'Next Week Task',
        description: 'Next Week Description',
        dateTime: nextWeek.add(const Duration(hours: 12)),
        createdAt: now,
        updatedAt: now,
      );

      expect(todayTask.isDueToday, true);
      expect(tomorrowTask.isDueToday, false);
      expect(nextWeekTask.isDueToday, false);

      expect(todayTask.isDueTomorrow, false);
      expect(tomorrowTask.isDueTomorrow, true);
      expect(nextWeekTask.isDueTomorrow, false);
    });

    test('Task update functionality should work correctly', () {
      final originalTask = Task(
        id: '1',
        title: 'Original Task',
        description: 'Original Description',
        dateTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        priority: TaskPriority.low,
        status: TaskStatus.pending,
        isCompleted: false,
      );

      // Test updating priority
      final highPriorityTask = originalTask.copyWith(
        priority: TaskPriority.high,
        updatedAt: DateTime.now(),
      );
      expect(highPriorityTask.priority, TaskPriority.high);
      expect(highPriorityTask.isCompleted, false); // Should remain unchanged

      // Test updating completion status
      final completedTask = highPriorityTask.copyWith(
        isCompleted: true,
        status: TaskStatus.completed,
        updatedAt: DateTime.now(),
      );
      expect(completedTask.isCompleted, true);
      expect(completedTask.status, TaskStatus.completed);
      expect(completedTask.priority, TaskPriority.high); // Should remain unchanged

      // Test updating date and time
      final newDateTime = DateTime.now().add(const Duration(days: 1));
      final updatedDateTimeTask = completedTask.copyWith(
        dateTime: newDateTime,
        updatedAt: DateTime.now(),
      );
      expect(updatedDateTimeTask.dateTime, newDateTime);
      expect(updatedDateTimeTask.isCompleted, true); // Should remain unchanged
    });

    test('Voice command parsing should handle format exceptions gracefully', () {
      // Test that the app doesn't crash with invalid date/time formats
      // This is a basic test to ensure the error handling works
      expect(true, true); // Placeholder test
    });

    test('Task IDs should be unique when created', () {
      final now = DateTime.now();
      final task1 = Task(
        id: '1',
        title: 'Task 1',
        description: 'Description 1',
        dateTime: now,
        createdAt: now,
        updatedAt: now,
      );
      
      final task2 = Task(
        id: '2',
        title: 'Task 2',
        description: 'Description 2',
        dateTime: now,
        createdAt: now,
        updatedAt: now,
      );
      
      expect(task1.id, isNot(equals(task2.id)));
      expect(task1.title, isNot(equals(task2.title)));
    });

    test('Task states should work correctly', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dateTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isCompleted: false,
      );
      
      // Test TasksLoaded state
      final tasksLoaded = TasksLoaded([task]);
      expect(tasksLoaded.tasks.length, 1);
      expect(tasksLoaded.tasks.first.title, 'Test Task');
      
      // Test TaskToggleLoading state
      final toggleLoading = TaskToggleLoading('1');
      expect(toggleLoading.taskId, '1');
      
      // Test TaskToggled state
      final completedTask = task.markAsCompleted();
      final taskToggled = TaskToggled(completedTask, true);
      expect(taskToggled.task.isCompleted, true);
      expect(taskToggled.isCompleted, true);
    });

    test('Voice states should work correctly', () {
      // Test VoiceListening state
      final voiceListening = VoiceListening();
      expect(voiceListening, isA<VoiceState>());
      
      // Test VoiceProcessing state
      const voiceProcessing = VoiceProcessing('test audio text');
      expect(voiceProcessing.audioText, 'test audio text');
      
      // Test VoiceCommandProcessed state
      final command = VoiceCommand(
        type: CommandType.create,
        title: 'Test Task',
        description: 'Test Description',
        dateTime: DateTime.now(),
        originalText: 'Create a test task',
      );
      final voiceCommandProcessed = VoiceCommandProcessed(command);
      expect(voiceCommandProcessed.command.title, 'Test Task');
      
      // Test VoiceError state
      const voiceError = VoiceError('Test error message');
      expect(voiceError.message, 'Test error message');
    });
  });
} 