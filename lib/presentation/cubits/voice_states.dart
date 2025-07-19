import 'package:equatable/equatable.dart';
import '../../domain/entities/voice_command.dart';

abstract class VoiceState extends Equatable {
  const VoiceState();

  @override
  List<Object?> get props => [];
}

class VoiceInitial extends VoiceState {}

class VoiceListening extends VoiceState {}

class VoiceRecording extends VoiceState {
  final Duration duration;
  
  const VoiceRecording(this.duration);
  
  @override
  List<Object?> get props => [duration];
}

class VoiceProcessing extends VoiceState {
  final String audioText;
  
  const VoiceProcessing(this.audioText);
  
  @override
  List<Object?> get props => [audioText];
}

class VoiceCommandProcessed extends VoiceState {
  final VoiceCommand command;

  const VoiceCommandProcessed(this.command);

  @override
  List<Object?> get props => [command];
}

class VoiceCommandRecognized extends VoiceState {
  final String recognizedText;
  final double confidence;

  const VoiceCommandRecognized(this.recognizedText, this.confidence);

  @override
  List<Object?> get props => [recognizedText, confidence];
}

class VoiceError extends VoiceState {
  final String message;

  const VoiceError(this.message);

  @override
  List<Object?> get props => [message];
}

class VoiceCommandInvalid extends VoiceState {
  final String reason;
  final String? originalText;

  const VoiceCommandInvalid(this.reason, [this.originalText]);

  @override
  List<Object?> get props => [reason, originalText];
}

class VoicePermissionDenied extends VoiceState {
  final String message;

  const VoicePermissionDenied(this.message);

  @override
  List<Object?> get props => [message];
}

class VoiceNotAvailable extends VoiceState {
  final String reason;

  const VoiceNotAvailable(this.reason);

  @override
  List<Object?> get props => [reason];
}

class VoiceIdle extends VoiceState {} 