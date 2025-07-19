import '../entities/voice_command.dart';
import '../repositories/voice_repository.dart';

class ProcessVoiceCommand {
  final VoiceRepository repository;

  ProcessVoiceCommand(this.repository);

  Future<VoiceCommand> call([String? text]) async {
    try {
      return await repository.processVoiceCommand(text);
    } catch (e) {
      return const VoiceCommand(
        type: CommandType.unknown,
        originalText: 'Error processing command',
        confidence: 0.0,
      );
    }
  }
} 