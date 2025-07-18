import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/main.dart';
import 'package:task_manager_app/domain/entities/task.dart';

void main() {
  group('Task Manager App Tests', () {
    testWidgets('App should start without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the app title is displayed
      expect(find.text('Task Manager'), findsOneWidget);
    });

    test('Task entity should work correctly', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dateTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(task.title, equals('Test Task'));
      expect(task.description, equals('Test Description'));
    });

    test('Task copyWith should work correctly', () {
      final originalTask = Task(
        id: '1',
        title: 'Original Task',
        description: 'Original Description',
        dateTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updatedTask = originalTask.copyWith(
        title: 'Updated Task',
        description: 'Updated Description',
      );

      expect(updatedTask.title, equals('Updated Task'));
      expect(updatedTask.description, equals('Updated Description'));
      expect(updatedTask.id, equals(originalTask.id));
    });
  });
} 