import '../entities/voice_command.dart';
import '../repositories/voice_repository.dart';

class ProcessVoiceCommand {
  final VoiceRepository repository;

  ProcessVoiceCommand(this.repository);

  Future<VoiceCommand> call([String? text]) async {
    try {
      String commandText;
      if (text != null) {
        commandText = text;
      } else {
        commandText = await repository.speechToText();
      }
      return await repository.parseVoiceCommand(commandText);
    } catch (e) {
      return VoiceCommand(
        type: CommandType.unknown,
        originalText: 'Error processing command',
        confidence: 0.0,
      );
    }
  }
} 