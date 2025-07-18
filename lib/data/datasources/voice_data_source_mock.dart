import '../../domain/entities/voice_command.dart';

abstract class VoiceDataSource {
  Future<String> speechToText();
  Future<VoiceCommand> parseVoiceCommand(String text);
}

class MockVoiceDataSourceImpl implements VoiceDataSource {
  // Enhanced mock speech-to-text with more realistic commands
  final List<String> _mockCommands = [
    "Create a task titled 'Grocery Shopping' at 5 PM on October 10",
    "Delete the task 'Grocery Shopping'",
    "Create a task called 'Team Meeting' tomorrow at 2:30 PM",
    "Update the task 'Team Meeting' to 3:00 PM",
    "Add a new task 'Doctor Appointment' at 10 AM today",
    "Remove the task 'Doctor Appointment'",
    "Create task 'Gym Workout' at 6 PM",
    "Update 'Gym Workout' to 7 PM tomorrow",
    "Delete task 'Gym Workout'",
    "Create a task titled 'Project Review' at 9 AM on December 15",
    "Schedule 'Dinner with Friends' at 8 PM tonight",
    "Cancel the task 'Dinner with Friends'",
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

    // Enhanced natural language parsing
    final lowerText = text.toLowerCase();
    
    // Extract intent
    CommandType intent;
    if (_containsAny(lowerText, ['create', 'add', 'new', 'schedule'])) {
      intent = CommandType.create;
    } else if (_containsAny(lowerText, ['update', 'change', 'modify', 'reschedule'])) {
      intent = CommandType.update;
    } else if (_containsAny(lowerText, ['delete', 'remove', 'cancel'])) {
      intent = CommandType.delete;
    } else {
      intent = CommandType.unknown;
    }

    // Extract task title
    String? title = _extractTitle(text, intent);
    
    // Extract date and time
    DateTime? dateTime = _extractDateTime(text);
    
    // Extract description (optional)
    String? description = _extractDescription(text);

    return VoiceCommand(
      type: intent,
      title: title,
      description: description,
      dateTime: dateTime,
      originalText: text,
      confidence: 0.95,
    );
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  String? _extractTitle(String text, CommandType intent) {
    // Simple title extraction using string operations
    final lowerText = text.toLowerCase();
    
    // Look for quoted text
    final singleQuoteStart = text.indexOf("'");
    final doubleQuoteStart = text.indexOf('"');
    
    int startIndex = -1;
    int endIndex = -1;
    
    if (singleQuoteStart != -1) {
      startIndex = singleQuoteStart + 1;
      endIndex = text.indexOf("'", startIndex);
    } else if (doubleQuoteStart != -1) {
      startIndex = doubleQuoteStart + 1;
      endIndex = text.indexOf('"', startIndex);
    }
    
    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return text.substring(startIndex, endIndex).trim();
    }
    
    return null;
  }

  DateTime? _extractDateTime(String text) {
    final now = DateTime.now();
    final lowerText = text.toLowerCase();

    // Extract time
    int? hour;
    int? minute = 0;
    
    // Match time patterns like "5 PM", "2:30 PM", "10 AM"
    final timePatterns = [
      RegExp(r'(\d{1,2}):(\d{2})\s*(am|pm)', caseSensitive: false),
      RegExp(r'(\d{1,2})\s*(am|pm)', caseSensitive: false),
    ];

    for (final pattern in timePatterns) {
      final match = pattern.firstMatch(lowerText);
      if (match != null) {
        hour = int.parse(match.group(1)!);
        if (match.groupCount >= 2 && match.group(2) != null) {
          minute = int.parse(match.group(2)!);
        }
        final period = match.group(match.groupCount)!.toLowerCase();
        
        // Convert to 24-hour format
        if (period == 'pm' && hour != 12) {
          hour += 12;
        } else if (period == 'am' && hour == 12) {
          hour = 0;
        }
        break;
      }
    }

    if (hour == null) return null;

    // Extract date
    DateTime targetDate = now;
    
    if (lowerText.contains('today')) {
      targetDate = now;
    } else if (lowerText.contains('tomorrow')) {
      targetDate = now.add(const Duration(days: 1));
    } else if (lowerText.contains('tonight')) {
      targetDate = now;
    } else {
      // Extract specific date patterns
      final datePatterns = [
        RegExp(r"on\s+(\w+)\s+(\d{1,2})", caseSensitive: false),
      ];

      for (final pattern in datePatterns) {
        final match = pattern.firstMatch(lowerText);
        if (match != null) {
          final monthName = match.group(1)!.toLowerCase();
          final day = int.parse(match.group(2)!);
          
          final monthMap = {
            'january': 1, 'february': 2, 'march': 3, 'april': 4,
            'may': 5, 'june': 6, 'july': 7, 'august': 8,
            'september': 9, 'october': 10, 'november': 11, 'december': 12,
          };

          final month = monthMap[monthName];
          if (month != null) {
            final year = now.year;
            // If the month has passed, assume next year
            final targetYear = (month < now.month) ? year + 1 : year;
            targetDate = DateTime(targetYear, month, day);
            break;
          }
        }
      }
    }

    return DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      hour!,
      minute!,
    );
  }

  String? _extractDescription(String text) {
    // Simple description extraction - could be enhanced
    if (text.toLowerCase().contains('description') || 
        text.toLowerCase().contains('details')) {
      // Extract text after "description" or "details"
      final patterns = [
        RegExp(r"description\s*:\s*(.+)", caseSensitive: false),
        RegExp(r"details\s*:\s*(.+)", caseSensitive: false),
      ];

      for (final pattern in patterns) {
        final match = pattern.firstMatch(text);
        if (match != null && match.groupCount >= 1) {
          return match.group(1)?.trim();
        }
      }
    }
    return null;
  }
} 