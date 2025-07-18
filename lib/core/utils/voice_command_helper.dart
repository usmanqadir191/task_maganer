import '../../domain/entities/voice_command.dart';

class VoiceCommandHelper {
  static String getCommandDescription(VoiceCommand command) {
    switch (command.type) {
      case CommandType.create:
        return 'Creating task: ${command.title}';
      case CommandType.update:
        return 'Updating task: ${command.title}';
      case CommandType.delete:
        return 'Deleting task: ${command.title}';
    }
  }

  static String getVoiceCommandExamples() {
    return '''
Voice Command Examples:

Create Tasks:
• "Create a task titled 'Team Meeting' at 8:50 PM"
• "Create a task titled 'Doctor Appointment' at 2:30 PM"

Update Tasks:
• "Update the task 'Team Meeting' to 7:50 PM"
• "Update the task 'Doctor Appointment' to 3:00 PM"

Delete Tasks:
• "Delete the task 'Team Meeting'"
• "Delete the task 'Doctor Appointment'"
''';
  }

  static bool isValidCommand(VoiceCommand command) {
    switch (command.type) {
      case CommandType.create:
        return command.title != null && command.dateTime != null;
      case CommandType.update:
        return command.title != null;
      case CommandType.delete:
        return command.title != null;
    }
  }
} 