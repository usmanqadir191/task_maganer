import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/voice_command.dart';
import '../../domain/usecases/process_voice_command.dart' as process_voice;

// States
abstract class VoiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VoiceInitial extends VoiceState {}

class VoiceListening extends VoiceState {}

class VoiceCommandProcessed extends VoiceState {
  final VoiceCommand command;

  VoiceCommandProcessed(this.command);

  @override
  List<Object?> get props => [command];
}

class VoiceError extends VoiceState {
  final String message;

  VoiceError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class VoiceCubit extends Cubit<VoiceState> {
  final process_voice.ProcessVoiceCommand processVoiceCommand;

  VoiceCubit({required this.processVoiceCommand}) : super(VoiceInitial());

  Future<void> startVoiceCommand() async {
    emit(VoiceListening());
    try {
      final command = await processVoiceCommand.call();
      emit(VoiceCommandProcessed(command));
    } catch (e) {
      emit(VoiceError(e.toString()));
    }
  }
} 