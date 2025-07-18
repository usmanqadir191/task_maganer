import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/voice_command.dart';
import '../../domain/usecases/process_voice_command.dart' as process_voice;

// States
abstract class VoiceState extends Equatable {
  const VoiceState();

  @override
  List<Object?> get props => [];
}

class VoiceInitial extends VoiceState {}

class VoiceListening extends VoiceState {}

class VoiceProcessing extends VoiceState {
  final String recognizedText;

  const VoiceProcessing(this.recognizedText);

  @override
  List<Object?> get props => [recognizedText];
}

class VoiceCommandProcessed extends VoiceState {
  final VoiceCommand command;

  const VoiceCommandProcessed(this.command);

  @override
  List<Object?> get props => [command];
}

class VoiceError extends VoiceState {
  final String message;

  const VoiceError(this.message);

  @override
  List<Object?> get props => [message];
}

class VoiceCommandInvalid extends VoiceState {
  final String recognizedText;
  final String reason;

  const VoiceCommandInvalid(this.recognizedText, this.reason);

  @override
  List<Object?> get props => [recognizedText, reason];
}

// Cubit
class VoiceCubit extends Cubit<VoiceState> {
  final process_voice.ProcessVoiceCommand processVoiceCommand;

  VoiceCubit({required this.processVoiceCommand}) : super(VoiceInitial());

  Future<void> startVoiceCommand() async {
    emit(VoiceListening());
    
    try {
      final command = await processVoiceCommand.call();
      
      if (command.isValid) {
        emit(VoiceCommandProcessed(command));
      } else {
        emit(VoiceCommandInvalid(
          command.originalText ?? 'Unknown',
          'Invalid command format or missing required information',
        ));
      }
    } catch (e) {
      emit(VoiceError(e.toString()));
    }
  }

  void reset() {
    emit(VoiceInitial());
  }
} 