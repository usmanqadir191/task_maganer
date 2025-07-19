import 'dart:async';
import '../../../core/services/gemini_service.dart';
import '../models/task_model.dart';

class VoiceDataSourceSimple {
  final GeminiService _geminiService = GeminiService();

  Future<String> startListening() async {
    await Future.delayed(const Duration(seconds: 2));
    return "Create a meeting at 3 PM today";
  }

  void stopListening() {}

  void cancelListening() {}

  Future<Map<String, dynamic>> processVoiceCommand(String voiceText) async {
    try {
      final result = await _geminiService.processVoiceCommand(voiceText);
      return result;
    } catch (e) {
      return {
        'action': 'unknown',
        'error': 'Error processing voice command: ${e.toString()}',
        'confidence': 0.0,
      };
    }
  }

  Future<String> getTaskSummary(List<TaskModel> tasks) async {
    try {
      final tasksData = tasks.map((task) => task.toJson()).toList();
      return await _geminiService.getTaskSummary(tasksData);
    } catch (e) {
      return 'Unable to generate task summary.';
    }
  }

  Future<String> getVoiceCommandSuggestions() async {
    try {
      return await _geminiService.getVoiceCommandSuggestions();
    } catch (e) {
      return '''
Try these voice commands:
• "Create a meeting at 3 PM today"
• "Add a task called grocery shopping"
• "Delete the meeting task"
• "Update meeting to 4 PM"
• "Create a high priority task for tomorrow"
''';
    }
  }

  bool get isListening => false;
  bool get isAvailable => true;
} 