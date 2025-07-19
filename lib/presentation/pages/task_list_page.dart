import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart' as di;
import '../cubits/task_cubit.dart';
import '../cubits/task_states.dart';
import '../cubits/voice_cubit.dart';
import '../cubits/voice_states.dart';
import '../widgets/task_card.dart';
import '../widgets/task_dialog.dart';
import '../widgets/voice_recording_button.dart';
import '../widgets/voice_recording_overlay.dart';
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
  List<Task> _previousTasks = [];

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
        onSave: (title, description, dateTime, priority, category) {
          _taskCubit.addTask(title, description, dateTime, priority, category);
        },
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        task: task,
        onSave: (title, description, dateTime, priority, category) {
          final updatedTask = task.copyWith(
            title: title,
            description: description,
            dateTime: dateTime,
            priority: priority,
            category: category,
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
            TaskPriority.medium,
            null,
          );
          _showSnackBar('✅ Task "${command.title}" created successfully!');
        } else if (command.title != null) {
          _taskCubit.addTask(
            command.title!,
            command.description ?? 'Created via voice command',
            DateTime.now().add(const Duration(hours: 1)),
            TaskPriority.medium,
            null,
          );
          _showSnackBar('✅ Task "${command.title}" created for later!');
        }
        break;
      case CommandType.update:
        if (command.title != null) {
          final currentState = _taskCubit.state;
          if (currentState is TasksLoaded) {
            try {
              final taskToUpdate = currentState.tasks.firstWhere(
                (task) => task.title.toLowerCase() == command.title!.toLowerCase(),
              );
              
              final updatedTask = taskToUpdate.copyWith(
                dateTime: command.dateTime ?? taskToUpdate.dateTime,
                description: command.description ?? taskToUpdate.description,
              );
              
              _taskCubit.editTask(updatedTask);
              _showSnackBar('✅ Task "${command.title}" updated successfully!');
            } catch (e) {
              _showSnackBar('❌ Task "${command.title}" not found');
            }
          }
        }
        break;
      case CommandType.delete:
        if (command.title != null) {
          final currentState = _taskCubit.state;
          if (currentState is TasksLoaded) {
            try {
              final taskToDelete = currentState.tasks.firstWhere(
                (task) => task.title.toLowerCase() == command.title!.toLowerCase(),
              );
              
              _taskCubit.removeTask(taskToDelete.id);
              _showSnackBar('✅ Task "${command.title}" deleted successfully!');
            } catch (e) {
              _showSnackBar('❌ Task "${command.title}" not found');
            }
          }
        }
        break;
      case CommandType.unknown:
        _showSnackBar('❌ Could not understand the voice command. Please try again.');
        break;
    }
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
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<VoiceCubit, VoiceState>(
                bloc: _voiceCubit,
                builder: (context, voiceState) {
                  return VoiceRecordingButton(
                    onRecordingStart: () => _voiceCubit.startRecording(),
                    onRecordingStop: () => _voiceCubit.stopRecording(),
                    onRecordingCancel: () => _voiceCubit.cancelRecording(),
                    isRecording: voiceState is VoiceRecording,
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
          body: Stack(
            children: [
              MultiBlocListener(
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
                      if (state is TaskCreated) {
                        _showSnackBar('✅ Task "${state.task.title}" created successfully!');
                      } else if (state is TaskUpdated) {
                        _showSnackBar('✅ Task "${state.task.title}" updated successfully!');
                      } else if (state is TaskToggled) {
                        final status = state.isCompleted ? 'completed' : 'uncompleted';
                        _showSnackBar('✅ Task "${state.task.title}" marked as $status!');
                      } else if (state is TaskDeleted) {
                        _showSnackBar('🗑️ Task deleted successfully!');
                      } else if (state is TaskError) {
                        _showSnackBar('❌ Error: ${state.message}');
                      } else if (state is TaskToggleError) {
                        _showSnackBar('❌ Toggle Error: ${state.message}');
                      } else if (state is TasksLoaded) {
                        if (_previousTasks.isNotEmpty && state.tasks.length == _previousTasks.length) {
                          for (int i = 0; i < state.tasks.length; i++) {
                            final currentTask = state.tasks[i];
                            final previousTask = _previousTasks[i];
                            if (currentTask.id == previousTask.id && 
                                currentTask.isCompleted != previousTask.isCompleted) {
                              final status = currentTask.isCompleted ? 'completed' : 'uncompleted';
                              _showSnackBar('✅ Task "${currentTask.title}" marked as $status!');
                              break;
                            }
                          }
                        }
                        _previousTasks = List.from(state.tasks);
                      }
                    },
                  ),
                ],
                child: BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    List<Task> tasksToShow = [];
                    
                    if (state is TasksLoaded) {
                      tasksToShow = state.tasks;
                    } else if (state is TaskToggleLoading || 
                              state is TaskCreateLoading || 
                              state is TaskUpdateLoading || 
                              state is TaskDeleteLoading) {
                      tasksToShow = _previousTasks;
                    }
                    
                    if (tasksToShow.isNotEmpty) {
                      return ListView.builder(
                        itemCount: tasksToShow.length,
                        itemBuilder: (context, index) {
                          final task = tasksToShow[index];
                          return TaskCard(
                            key: ValueKey(task.id),
                            task: task,
                            onEdit: () => _showEditTaskDialog(task),
                            onToggleComplete: () => _taskCubit.toggleTaskCompletion(task.id),
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
                    
                    if (state is TasksLoaded && state.tasks.isEmpty) {
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

                    if (state is TaskError || state is TaskToggleError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Something went wrong',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state is TaskError ? state.message : (state as TaskToggleError).message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _taskCubit.loadTasks(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              BlocBuilder<VoiceCubit, VoiceState>(
                bloc: _voiceCubit,
                builder: (context, voiceState) {
                  return VoiceRecordingOverlay(
                    isVisible: voiceState is VoiceRecording,
                    onCancel: () => _voiceCubit.cancelRecording(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 