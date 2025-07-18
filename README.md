# Task Manager App

A Flutter mobile application built with Clean Architecture, featuring voice command functionality for task management.

## Features

- **Clean Architecture**: Organized into Presentation, Domain, and Data layers
- **State Management**: Uses Cubit (flutter_bloc) for reactive state management
- **Voice Commands**: Mock voice command simulation with predefined commands
- **Task Management**: Create, read, update, and delete tasks
- **Chronological Sorting**: Tasks are automatically sorted by date and time
- **Modern UI**: Material Design 3 with beautiful task cards
- **Dependency Injection**: Uses get_it for service locator pattern

## Architecture

### Domain Layer
- **Entities**: Core business objects (Task, VoiceCommand)
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business logic implementation

### Data Layer
- **Models**: Data transfer objects extending domain entities
- **Data Sources**: Concrete implementations for data access
- **Repository Implementations**: Bridge between domain and data layers

### Presentation Layer
- **Cubits**: State management for UI
- **Pages**: Main application screens
- **Widgets**: Reusable UI components

## Voice Commands (Demo Mode)

The app currently runs in demo mode with mock voice commands. The microphone button cycles through predefined commands to demonstrate the functionality:

### Create Task
```
"Create a task titled 'Team Meeting' at 8:50 PM"
"Create a task titled 'Doctor Appointment' at 2:30 PM"
"Create a task titled 'Gym Workout' at 6:00 PM"
```

### Update Task
```
"Update the task 'Team Meeting' to 7:50 PM"
```

### Delete Task
```
"Delete the task 'Team Meeting'"
```

**Note**: Real speech-to-text functionality was temporarily disabled due to Android NDK compatibility issues. The mock implementation demonstrates the complete voice command workflow.

## Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd task_manager_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Permissions

The app requires the following permissions:
- **RECORD_AUDIO**: For voice command functionality
- **INTERNET**: For future API integrations

## Dependencies

### Core Dependencies
- `flutter_bloc`: State management
- `get_it`: Dependency injection
- `speech_to_text`: Voice recognition
- `intl`: Date and time formatting
- `equatable`: Value equality

### Development Dependencies
- `flutter_lints`: Code quality and style

## Project Structure

```
lib/
├── core/
│   └── di/
│       └── injection_container.dart
├── data/
│   ├── datasources/
│   │   ├── task_local_data_source.dart
│   │   └── voice_data_source.dart
│   ├── models/
│   │   └── task_model.dart
│   └── repositories/
│       ├── task_repository_impl.dart
│       └── voice_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── task.dart
│   │   └── voice_command.dart
│   ├── repositories/
│   │   ├── task_repository.dart
│   │   └── voice_repository.dart
│   └── usecases/
│       ├── create_task.dart
│       ├── delete_task.dart
│       ├── get_all_tasks.dart
│       ├── process_voice_command.dart
│       └── update_task.dart
├── presentation/
│   ├── cubits/
│   │   ├── task_cubit_simple.dart
│   │   └── voice_cubit_simple.dart
│   ├── pages/
│   │   └── task_list_page.dart
│   └── widgets/
│       ├── task_card.dart
│       └── task_dialog.dart
└── main.dart
```

## Usage

### Adding Tasks
1. Tap the "+" floating action button
2. Fill in the task details (title, description, date/time)
3. Tap "Add" to create the task

### Editing Tasks
1. Tap the edit icon on any task card
2. Modify the task details
3. Tap "Save" to update the task

### Deleting Tasks
1. Tap the delete icon on any task card
2. Confirm the deletion in the dialog

### Voice Commands
1. Tap the microphone floating action button
2. Speak your command clearly
3. The app will process and execute the command

## Mock LLM Integration

The app includes a mock LLM service that processes voice commands. In a production environment, this would be replaced with a real LLM API (e.g., OpenAI GPT, Google Gemini).

### Command Processing
- **Speech-to-Text**: Converts voice input to text
- **Command Parsing**: Extracts intent and parameters
- **Task Operations**: Executes the appropriate task action

## Future Enhancements

- [ ] Real LLM API integration
- [ ] Cloud storage for tasks
- [ ] Task categories and tags
- [ ] Reminder notifications
- [ ] Task sharing
- [ ] Offline support
- [ ] Dark theme
- [ ] Task templates

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- BLoC pattern for state management
- Clean Architecture principles by Robert C. Martin
