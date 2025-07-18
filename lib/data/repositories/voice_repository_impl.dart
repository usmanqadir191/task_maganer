import '../../domain/entities/voice_command.dart';
import '../../domain/repositories/voice_repository.dart';
import '../datasources/voice_data_source_mock.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceDataSource voiceDataSource;

  VoiceRepositoryImpl(this.voiceDataSource);

  @override
  Future<String> speechToText() async {
    return await voiceDataSource.speechToText();
  }

  @override
  Future<VoiceCommand> parseVoiceCommand(String text) async {
    return await voiceDataSource.parseVoiceCommand(text);
  }
} 