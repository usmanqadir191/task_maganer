import 'package:equatable/equatable.dart';

enum CommandType {
  create,
  update,
  delete,
  unknown,
}

class VoiceCommand extends Equatable {
  final CommandType type;
  final String? title;
  final String? description;
  final DateTime? dateTime;
  final String? originalText;
  final double confidence;

  const VoiceCommand({
    required this.type,
    this.title,
    this.description,
    this.dateTime,
    this.originalText,
    this.confidence = 1.0,
  });

  VoiceCommand copyWith({
    CommandType? type,
    String? title,
    String? description,
    DateTime? dateTime,
    String? originalText,
    double? confidence,
  }) {
    return VoiceCommand(
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      originalText: originalText ?? this.originalText,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  List<Object?> get props => [
        type,
        title,
        description,
        dateTime,
        originalText,
        confidence,
      ];

  bool get isValid {
    switch (type) {
      case CommandType.create:
        return title != null && title!.isNotEmpty;
      case CommandType.update:
      case CommandType.delete:
        return title != null && title!.isNotEmpty;
      case CommandType.unknown:
        return false;
    }
  }

  String get displayText {
    switch (type) {
      case CommandType.create:
        return 'Create task: "$title"${dateTime != null ? ' at ${_formatDateTime(dateTime!)}' : ''}';
      case CommandType.update:
        return 'Update task: "$title"${dateTime != null ? ' to ${_formatDateTime(dateTime!)}' : ''}';
      case CommandType.delete:
        return 'Delete task: "$title"';
      case CommandType.unknown:
        return 'Unknown command: "$originalText"';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateText;
    if (taskDate == today) {
      dateText = 'today';
    } else if (taskDate == tomorrow) {
      dateText = 'tomorrow';
    } else {
      dateText = '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }

    final timeText = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$timeText on $dateText';
  }
} 