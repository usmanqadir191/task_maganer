import '../../domain/entities/voice_command.dart';

abstract class VoiceDataSource {
  Future<String> speechToText();
  Future<VoiceCommand> parseVoiceCommand(String text);
}

class MockVoiceDataSourceImpl implements VoiceDataSource {
  String? _currentText;

  void setText(String text) {
    _currentText = text;
  }

  @override
  Future<String> speechToText() async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (_currentText != null) {
      final text = _currentText!;
      _currentText = null;
      return text;
    }
    
    return "Create a task called 'Test Task' at 3 PM today";
  }

  @override
  Future<VoiceCommand> parseVoiceCommand(String text) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final lowerText = text.toLowerCase();
    
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

    String? title = _extractTitle(text, intent);
    DateTime? dateTime = _extractDateTime(text);
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
    try {
      final now = DateTime.now();
      final lowerText = text.toLowerCase();

      int? hour;
      int? minute = 0;
      
      final timePatterns = [
        RegExp(r'(\d{1,2}):(\d{2})\s*(am|pm)', caseSensitive: false),
        RegExp(r'(\d{1,2})\s*(am|pm)', caseSensitive: false),
      ];

      for (final pattern in timePatterns) {
        final match = pattern.firstMatch(lowerText);
        if (match != null) {
          try {
            final hourStr = match.group(1);
            if (hourStr == null) continue;
            
            hour = int.parse(hourStr);
            
            if (pattern.pattern.contains(':') && match.groupCount >= 2) {
              final minuteStr = match.group(2);
              if (minuteStr != null) {
                minute = int.parse(minuteStr);
              }
            }
            
            final periodGroup = match.group(match.groupCount);
            if (periodGroup == null) continue;
            
            final period = periodGroup.toLowerCase();
            
            if (hour < 1 || hour > 12 || (minute ?? 0) < 0 || (minute ?? 0) > 59) {
              continue;
            }
            
            if (period == 'pm' && hour != 12) {
              hour += 12;
            } else if (period == 'am' && hour == 12) {
              hour = 0;
            }
            break;
          } catch (e) {
            continue;
          }
        }
      }

      if (hour == null) return null;

      DateTime targetDate = now;
      
      if (lowerText.contains('today')) {
        targetDate = now;
      } else if (lowerText.contains('tomorrow')) {
        targetDate = now.add(const Duration(days: 1));
      } else if (lowerText.contains('tonight')) {
        targetDate = now;
      } else {
        final datePatterns = [
          RegExp(r"on\s+(\w+)\s+(\d{1,2})", caseSensitive: false),
        ];

        for (final pattern in datePatterns) {
          final match = pattern.firstMatch(lowerText);
          if (match != null) {
            try {
              final monthNameGroup = match.group(1);
              final dayStr = match.group(2);
              
              if (monthNameGroup == null || dayStr == null) {
                continue;
              }
              
              final monthName = monthNameGroup.toLowerCase();
              final day = int.parse(dayStr);
              
              if (day < 1 || day > 31) {
                continue;
              }
              
              final monthMap = {
                'january': 1, 'february': 2, 'march': 3, 'april': 4,
                'may': 5, 'june': 6, 'july': 7, 'august': 8,
                'september': 9, 'october': 10, 'november': 11, 'december': 12,
              };

              final month = monthMap[monthName];
              if (month != null) {
                final year = now.year;
                final targetYear = (month < now.month) ? year + 1 : year;
                
                try {
                  targetDate = DateTime(targetYear, month, day);
                  if (targetDate.month != month || targetDate.day != day) {
                    continue;
                  }
                  break;
                } catch (e) {
                  continue;
                }
              }
            } catch (e) {
              continue;
            }
          }
        }
      }

      try {
        final result = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          hour!,
          minute!,
        );
        
        if (result.hour != hour || result.minute != (minute ?? 0)) {
          return null;
        }
        
        return result;
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  String? _extractDescription(String text) {
    if (text.toLowerCase().contains('description') || 
        text.toLowerCase().contains('details')) {
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