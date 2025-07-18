import '../entities/voice_command.dart';
import '../repositories/voice_repository.dart';

class ProcessVoiceCommand {
  final VoiceRepository repository;

  ProcessVoiceCommand(this.repository);

  Future<VoiceCommand> call() async {
    final text = await repository.speechToText();
    return await repository.parseVoiceCommand(text);
  }
} 