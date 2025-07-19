import '../entities/voice_command.dart';
import '../../data/models/task_model.dart';

abstract class VoiceRepository {
  Future<VoiceCommand> processVoiceCommand([String? textInput]);
  Future<String> getTaskSummary(List<TaskModel> tasks);
  Future<String> getVoiceCommandSuggestions();
} 