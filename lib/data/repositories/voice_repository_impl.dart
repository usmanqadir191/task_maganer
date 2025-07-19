import '../../domain/entities/voice_command.dart';
import '../../domain/repositories/voice_repository.dart';
import '../datasources/voice_data_source_simple.dart';
import '../models/task_model.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceDataSourceSimple _voiceDataSource;

  VoiceRepositoryImpl(this._voiceDataSource);

  @override
  Future<VoiceCommand> processVoiceCommand([String? textInput]) async {
    try {
      String voiceText;
      
      if (textInput != null) {
        voiceText = textInput;
      } else {
        voiceText = await _voiceDataSource.startListening();
      }

      final result = await _voiceDataSource.processVoiceCommand(voiceText);
      
      return VoiceCommand(
        type: _parseCommandType(result['action']),
        title: result['title'],
        description: result['description'],
        dateTime: result['dateTime'] != null ? DateTime.parse(result['dateTime']) : null,
        originalText: voiceText,
        confidence: result['confidence']?.toDouble() ?? 0.0,
      );
    } catch (e) {
      return const VoiceCommand(
        type: CommandType.unknown,
        originalText: 'Voice input',
        confidence: 0.0,
      );
    }
  }

  @override
  Future<String> getTaskSummary(List<TaskModel> tasks) async {
    return await _voiceDataSource.getTaskSummary(tasks);
  }

  @override
  Future<String> getVoiceCommandSuggestions() async {
    return await _voiceDataSource.getVoiceCommandSuggestions();
  }

  CommandType _parseCommandType(String? action) {
    switch (action?.toLowerCase()) {
      case 'create':
        return CommandType.create;
      case 'update':
        return CommandType.update;
      case 'delete':
        return CommandType.delete;
      default:
        return CommandType.unknown;
    }
  }
} 