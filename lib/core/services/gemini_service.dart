import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/gemini_config.dart';

class GeminiService {
  late final GenerativeModel? _model;
  
  GeminiService() {
    if (GeminiConfig.isConfigured) {
      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: GeminiConfig.apiKey,
      );
    } else {
      _model = null;
    }
  }

  Future<Map<String, dynamic>> processVoiceCommand(String voiceText) async {
    if (_model == null) {
      return {
        'action': 'unknown',
        'error': 'Gemini API not configured. Please add your API key.',
        'confidence': 0.0,
      };
    }

    try {
      final prompt = '''
You are a task management assistant. Analyze the following voice command and extract task information.

Voice Command: "$voiceText"

Return a JSON object with the following structure:
{
  "action": "create|update|delete|unknown",
  "title": "task title if mentioned",
  "description": "task description if mentioned",
  "dateTime": "ISO datetime string if mentioned, or null",
  "priority": "high|medium|low|null",
  "confidence": 0.0-1.0,
  "error": "error message if any, or null"
}

Rules:
- For CREATE: Extract title, description, date/time, priority
- For UPDATE: Extract title and what to update
- For DELETE: Extract title of task to delete
- If unclear, set action to "unknown" and provide error message
- Convert natural language dates to ISO format (e.g., "3 PM today" → current date + 15:00)
- Set confidence based on how clear the command is

Examples:
- "Create a meeting at 3 PM today" → {"action": "create", "title": "meeting", "dateTime": "2024-01-15T15:00:00Z"}
- "Delete the grocery shopping task" → {"action": "delete", "title": "grocery shopping"}
- "Update meeting to 4 PM" → {"action": "update", "title": "meeting", "dateTime": "2024-01-15T16:00:00Z"}

Return ONLY the JSON object, no additional text.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text ?? '';
      
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(responseText);
      if (jsonMatch == null) {
        return {
          'action': 'unknown',
          'error': 'Could not parse response from AI',
          'confidence': 0.0,
        };
      }

      final jsonString = jsonMatch.group(0)!;
      final result = json.decode(jsonString) as Map<String, dynamic>;
      
      return result;
    } catch (e) {
      return {
        'action': 'unknown',
        'error': 'Error processing voice command: ${e.toString()}',
        'confidence': 0.0,
      };
    }
  }

  Future<String> getTaskSummary(List<Map<String, dynamic>> tasks) async {
    if (_model == null) {
      return 'AI not configured. Please add your Gemini API key.';
    }

    try {
      final tasksJson = json.encode(tasks);
      final prompt = '''
You are a helpful assistant. Here are the current tasks:

$tasksJson

Provide a brief, friendly summary of the tasks. Include:
- Total number of tasks
- How many are completed vs pending
- Any high priority tasks
- Upcoming deadlines

Keep it concise and encouraging.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'No tasks available.';
    } catch (e) {
      return 'Unable to generate task summary.';
    }
  }

  Future<String> getVoiceCommandSuggestions() async {
    if (_model == null) {
      return '''
Try these voice commands:
• "Create a meeting at 3 PM today"
• "Add a task called grocery shopping"
• "Delete the meeting task"
• "Update meeting to 4 PM"
• "Create a high priority task for tomorrow"
''';
    }

    try {
      const prompt = '''
Provide 5 helpful voice command examples for a task manager app. 
Format as a simple list with clear, natural language examples.

Focus on:
- Creating tasks with time/date
- Updating existing tasks
- Deleting tasks
- Checking task status

Make them conversational and easy to remember.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Try saying: "Create a meeting at 3 PM today"';
    } catch (e) {
      return 'Try saying: "Create a meeting at 3 PM today"';
    }
  }
} 