import 'dart:convert';
import '../../domain/entities/voice_command.dart';

abstract class VoiceDataSource {
  Future<String> speechToText();
  Future<VoiceCommand> parseVoiceCommand(String text);
}

class MockVoiceDataSourceImpl implements VoiceDataSource {
  // Mock speech-to-text that returns predefined commands for demo
  final List<String> _mockCommands = [
    "Create a task titled 'Team Meeting' at 8:50 PM",
    "Create a task titled 'Doctor Appointment' at 2:30 PM",
    "Update the task 'Team Meeting' to 7:50 PM",
    "Delete the task 'Team Meeting'",
    "Create a task titled 'Gym Workout' at 6:00 PM",
  ];

  int _commandIndex = 0;

  @override
  Future<String> speechToText() async {
    // Simulate speech recognition delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Cycle through mock commands
    final command = _mockCommands[_commandIndex % _mockCommands.length];
    _commandIndex++;
    
    return command;
  }

  @override
  Future<VoiceCommand> parseVoiceCommand(String text) async {
    // Simulate LLM processing delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock LLM response based on input text
    final lowerText = text.toLowerCase();
    
    if (lowerText.contains('create') && lowerText.contains('task')) {
      final response = _extractCreateTaskResponse(text);
      return _parseLLMResponse(response);
    } else if (lowerText.contains('update') && lowerText.contains('task')) {
      final response = _extractUpdateTaskResponse(text);
      return _parseLLMResponse(response);
    } else if (lowerText.contains('delete') && lowerText.contains('task')) {
      final response = _extractDeleteTaskResponse(text);
      return _parseLLMResponse(response);
    }
    
    throw Exception('Unrecognized command');
  }

  String _extractCreateTaskResponse(String text) {
    // Simple parsing for demo - in real app, use proper NLP
    String title = 'Untitled Task';
    String description = 'Created via voice command';
    DateTime dateTime = DateTime.now();
    
    // Extract title if present
    if (text.contains('titled')) {
      final parts = text.split('titled');
      if (parts.length > 1) {
        final titlePart = parts[1].trim();
        if (titlePart.contains('at') || titlePart.contains('on')) {
          final titleEnd = titlePart.indexOf(' at');
          if (titleEnd == -1) {
            title = titlePart.substring(0, titlePart.indexOf(' on')).trim();
          } else {
            title = titlePart.substring(0, titleEnd).trim();
          }
        } else {
          title = titlePart.trim();
        }
      }
    }
    
    // Extract time if present
    if (text.contains('at') && text.contains('PM')) {
      final timeMatch = RegExp(r'(\d{1,2}):(\d{2})\s*PM').firstMatch(text);
      if (timeMatch != null) {
        final hour = int.parse(timeMatch.group(1)!);
        final minute = int.parse(timeMatch.group(2)!);
        final adjustedHour = hour == 12 ? 12 : hour + 12;
        dateTime = DateTime.now().copyWith(hour: adjustedHour, minute: minute);
      }
    } else if (text.contains('at') && text.contains('AM')) {
      final timeMatch = RegExp(r'(\d{1,2}):(\d{2})\s*AM').firstMatch(text);
      if (timeMatch != null) {
        final hour = int.parse(timeMatch.group(1)!);
        final minute = int.parse(timeMatch.group(2)!);
        final adjustedHour = hour == 12 ? 0 : hour;
        dateTime = DateTime.now().copyWith(hour: adjustedHour, minute: minute);
      }
    }
    
    return json.encode({
      'type': 'create',
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    });
  }

  String _extractUpdateTaskResponse(String text) {
    String? title;
    DateTime? dateTime;
    
    // Extract title if present
    if (text.contains('task')) {
      final parts = text.split('task');
      if (parts.length > 1) {
        final titlePart = parts[1].trim();
        if (titlePart.contains('to')) {
          title = titlePart.substring(0, titlePart.indexOf(' to')).trim();
        } else {
          title = titlePart.trim();
        }
      }
    }
    
    // Extract time if present
    if (text.contains('to') && text.contains('PM')) {
      final timeMatch = RegExp(r'(\d{1,2}):(\d{2})\s*PM').firstMatch(text);
      if (timeMatch != null) {
        final hour = int.parse(timeMatch.group(1)!);
        final minute = int.parse(timeMatch.group(2)!);
        final adjustedHour = hour == 12 ? 12 : hour + 12;
        dateTime = DateTime.now().copyWith(hour: adjustedHour, minute: minute);
      }
    } else if (text.contains('to') && text.contains('AM')) {
      final timeMatch = RegExp(r'(\d{1,2}):(\d{2})\s*AM').firstMatch(text);
      if (timeMatch != null) {
        final hour = int.parse(timeMatch.group(1)!);
        final minute = int.parse(timeMatch.group(2)!);
        final adjustedHour = hour == 12 ? 0 : hour;
        dateTime = DateTime.now().copyWith(hour: adjustedHour, minute: minute);
      }
    }
    
    return json.encode({
      'type': 'update',
      'title': title,
      'dateTime': dateTime?.toIso8601String(),
    });
  }

  String _extractDeleteTaskResponse(String text) {
    String? title;
    
    // Extract title if present
    if (text.contains('task')) {
      final parts = text.split('task');
      if (parts.length > 1) {
        title = parts[1].trim();
      }
    }
    
    return json.encode({
      'type': 'delete',
      'title': title,
    });
  }

  VoiceCommand _parseLLMResponse(String response) {
    final data = json.decode(response) as Map<String, dynamic>;
    final type = data['type'] as String;
    
    switch (type) {
      case 'create':
        return VoiceCommand(
          type: CommandType.create,
          title: data['title'] as String?,
          description: data['description'] as String?,
          dateTime: data['dateTime'] != null ? DateTime.parse(data['dateTime'] as String) : null,
        );
      case 'update':
        return VoiceCommand(
          type: CommandType.update,
          title: data['title'] as String?,
          dateTime: data['dateTime'] != null ? DateTime.parse(data['dateTime'] as String) : null,
        );
      case 'delete':
        return VoiceCommand(
          type: CommandType.delete,
          title: data['title'] as String?,
        );
      default:
        throw Exception('Unknown command type');
    }
  }
} 