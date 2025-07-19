import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/process_voice_command.dart' as process_voice;
import 'voice_states.dart';

class VoiceCubit extends Cubit<VoiceState> {
  final process_voice.ProcessVoiceCommand processVoiceCommand;
  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;

  VoiceCubit({required this.processVoiceCommand}) : super(VoiceInitial());

  void startRecording() {
    emit(VoiceRecording(Duration.zero));
    _recordingDuration = Duration.zero;
    
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordingDuration += const Duration(seconds: 1);
      emit(VoiceRecording(_recordingDuration));
    });
  }

  void stopRecording() {
    _recordingTimer?.cancel();
    emit(VoiceProcessing('Processing voice command...'));
    
    _processVoiceCommand();
  }

  void cancelRecording() {
    _recordingTimer?.cancel();
    emit(VoiceInitial());
  }

  void _processVoiceCommand() async {
    try {
      final command = await processVoiceCommand.call();
      
      if (command.isValid) {
        emit(VoiceCommandProcessed(command));
      } else {
        emit(VoiceCommandInvalid(
          'Invalid command format or missing required information',
          command.originalText,
        ));
      }
    } catch (e) {
      String errorMessage = 'Voice command error';
      
      if (e.toString().contains('FormatException')) {
        errorMessage = 'Error parsing date/time format. Please try again with a clearer format.';
      } else if (e.toString().contains('Exception')) {
        errorMessage = 'Error processing voice command: ${e.toString()}';
      } else {
        errorMessage = e.toString();
      }
      
      emit(VoiceError(errorMessage));
    }
  }

  Future<void> startVoiceCommand() async {
    emit(VoiceListening());
    
    try {
      final command = await processVoiceCommand.call();
      
      if (command.isValid) {
        emit(VoiceCommandProcessed(command));
      } else {
        emit(VoiceCommandInvalid(
          'Invalid command format or missing required information',
          command.originalText,
        ));
      }
    } catch (e) {
      String errorMessage = 'Voice command error';
      
      if (e.toString().contains('FormatException')) {
        errorMessage = 'Error parsing date/time format. Please try again with a clearer format.';
      } else if (e.toString().contains('Exception')) {
        errorMessage = 'Error processing voice command: ${e.toString()}';
      } else {
        errorMessage = e.toString();
      }
      
      emit(VoiceError(errorMessage));
    }
  }

  Future<void> processTextCommand(String text) async {
    emit(VoiceProcessing(text));
    
    try {
      final command = await processVoiceCommand.call(text);
      
      if (command.isValid) {
        emit(VoiceCommandProcessed(command));
      } else {
        emit(VoiceCommandInvalid(
          'Invalid command format or missing required information',
          text,
        ));
      }
    } catch (e) {
      String errorMessage = 'Command processing error';
      
      if (e.toString().contains('FormatException')) {
        errorMessage = 'Error parsing date/time format. Please try again with a clearer format.';
      } else if (e.toString().contains('Exception')) {
        errorMessage = 'Error processing command: ${e.toString()}';
      } else {
        errorMessage = e.toString();
      }
      
      emit(VoiceError(errorMessage));
    }
  }

  void reset() {
    _recordingTimer?.cancel();
    emit(VoiceInitial());
  }

  @override
  Future<void> close() {
    _recordingTimer?.cancel();
    return super.close();
  }
} 