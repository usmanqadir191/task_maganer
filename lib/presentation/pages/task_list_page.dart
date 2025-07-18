import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart' as di;
import '../cubits/task_cubit.dart';
import '../cubits/voice_cubit.dart';
import '../widgets/task_card.dart';
import '../widgets/task_dialog.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/voice_command.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late TaskCubit _taskCubit;
  late VoiceCubit _voiceCubit;

  @override
  void initState() {
    super.initState();
    _taskCubit = di.sl<TaskCubit>();
    _voiceCubit = di.sl<VoiceCubit>();
    _taskCubit.loadTasks();
  }

  @override
  void dispose() {
    _taskCubit.close();
    _voiceCubit.close();
    super.dispose();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        onSave: (title, description, dateTime) {
          _taskCubit.addTask(title, description, dateTime);
        },
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        task: task,
        onSave: (title, description, dateTime) {
          final updatedTask = task.copyWith(
            title: title,
            description: description,
            dateTime: dateTime,
          );
          _taskCubit.editTask(updatedTask);
        },
      ),
    );
  }

  void _handleVoiceCommand(VoiceCommand command) {
    switch (command.type) {
      case CommandType.create:
        if (command.title != null && command.dateTime != null) {
          _taskCubit.addTask(
            command.title!,
            command.description ?? 'Created via voice command',
            command.dateTime!,
          );
          _showSnackBar('✅ Task "${command.title}" created successfully!');
        } else if (command.title != null) {
          // Create task without specific time
          _taskCubit.addTask(
            command.title!,
            command.description ?? 'Created via voice command',
            DateTime.now().add(const Duration(hours: 1)),
          );
          _showSnackBar('✅ Task "${command.title}" created for later!');
        }
        break;
      case CommandType.update:
        if (command.title != null) {
          // Find the task by title and update it
          final currentState = _taskCubit.state;
          if (currentState is TasksLoaded) {
            final taskToUpdate = currentState.tasks.firstWhere(
              (task) => task.title.toLowerCase() == command.title!.toLowerCase(),
              orElse: () => throw Exception('Task not found'),
            );
            
            final updatedTask = taskToUpdate.copyWith(
              dateTime: command.dateTime ?? taskToUpdate.dateTime,
              description: command.description ?? taskToUpdate.description,
            );
            
            _taskCubit.editTask(updatedTask);
            _showSnackBar('✅ Task "${command.title}" updated successfully!');
          }
        }
        break;
      case CommandType.delete:
        if (command.title != null) {
          // Find the task by title and delete it
          final currentState = _taskCubit.state;
          if (currentState is TasksLoaded) {
            final taskToDelete = currentState.tasks.firstWhere(
              (task) => task.title.toLowerCase() == command.title!.toLowerCase(),
              orElse: () => throw Exception('Task not found'),
            );
            
            _taskCubit.removeTask(taskToDelete.id);
            _showSnackBar('✅ Task "${command.title}" deleted successfully!');
          }
        }
        break;
      case CommandType.unknown:
        _showSnackBar('❌ Could not understand the voice command. Please try again.');
        break;
    }
  }

  void _showVoiceInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎤 Voice Commands'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This is an enhanced demo with sophisticated voice command parsing!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('📝 Example Commands:'),
            SizedBox(height: 8),
            Text('• "Create a task titled \'Grocery Shopping\' at 5 PM on October 10"'),
            Text('• "Delete the task \'Grocery Shopping\'"'),
            Text('• "Create a task called \'Team Meeting\' tomorrow at 2:30 PM"'),
            Text('• "Update the task \'Team Meeting\' to 3:00 PM"'),
            Text('• "Add a new task \'Doctor Appointment\' at 10 AM today"'),
            SizedBox(height: 16),
            Text(
              '🔧 Features:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• Natural language processing'),
            Text('• Date/time extraction'),
            Text('• Intent recognition'),
            Text('• Task title extraction'),
            Text('• Error handling & validation'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskCubit>.value(
      value: _taskCubit,
      child: BlocProvider<VoiceCubit>.value(
        value: _voiceCubit,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Task Manager'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<VoiceCubit, VoiceState>(
                listener: (context, state) {
                  if (state is VoiceCommandProcessed) {
                    _handleVoiceCommand(state.command);
                  } else if (state is VoiceError) {
                    _showSnackBar('❌ Voice command error: ${state.message}');
                  } else if (state is VoiceCommandInvalid) {
                    _showSnackBar('❌ Invalid command: ${state.reason}');
                  }
                },
              ),
              BlocListener<TaskCubit, TaskState>(
                listener: (context, state) {
                  if (state is TaskError) {
                    _showSnackBar('Error: ${state.message}');
                  }
                },
              ),
            ],
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TasksLoaded) {
                  if (state.tasks.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No tasks yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap the + button to add a task',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return TaskCard(
                        task: task,
                        onEdit: () => _showEditTaskDialog(task),
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Task'),
                              content: Text('Are you sure you want to delete "${task.title}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _taskCubit.removeTask(task.id);
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return const Center(
                  child: Text('Something went wrong'),
                );
              },
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<VoiceCubit, VoiceState>(
                bloc: _voiceCubit,
                builder: (context, voiceState) {
                  return FloatingActionButton(
                    heroTag: 'voice',
                    onPressed: voiceState is VoiceListening
                        ? null
                        : () {
                            _showVoiceInfo();
                            _voiceCubit.startVoiceCommand();
                          },
                    backgroundColor: voiceState is VoiceListening
                        ? Colors.grey
                        : Colors.orange,
                    child: Icon(
                      voiceState is VoiceListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'add',
                onPressed: _showAddTaskDialog,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 