import 'package:equatable/equatable.dart';

enum CommandType { create, update, delete }

class VoiceCommand extends Equatable {
  final CommandType type;
  final String? title;
  final String? description;
  final DateTime? dateTime;

  const VoiceCommand({
    required this.type,
    this.title,
    this.description,
    this.dateTime,
  });

  @override
  List<Object?> get props => [type, title, description, dateTime];
} 