import 'package:get_it/get_it.dart';
import '../../data/datasources/task_local_data_source.dart';
import '../../data/datasources/voice_data_source_mock.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/repositories/voice_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/voice_repository.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/create_task.dart' as create_task;
import '../../domain/usecases/update_task.dart' as update_task;
import '../../domain/usecases/delete_task.dart' as delete_task;
import '../../domain/usecases/process_voice_command.dart' as process_voice;
import '../../presentation/cubits/task_cubit.dart';
import '../../presentation/cubits/voice_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => TaskCubit(
      getAllTasks: sl(),
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
    ),
  );

  sl.registerFactory(
    () => VoiceCubit(
      processVoiceCommand: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllTasks(sl()));
  sl.registerLazySingleton(() => create_task.CreateTask(sl()));
  sl.registerLazySingleton(() => update_task.UpdateTask(sl()));
  sl.registerLazySingleton(() => delete_task.DeleteTask(sl()));
  sl.registerLazySingleton(() => process_voice.ProcessVoiceCommand(sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<VoiceRepository>(
    () => VoiceRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<VoiceDataSource>(
    () => MockVoiceDataSourceImpl(),
  );
} 