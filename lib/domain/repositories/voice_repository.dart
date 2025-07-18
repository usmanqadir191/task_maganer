import '../entities/voice_command.dart';

abstract class VoiceRepository {
  Future<String> speechToText();
  Future<VoiceCommand> parseVoiceCommand(String text);
} 