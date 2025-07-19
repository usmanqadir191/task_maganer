import 'package:get_it/get_it.dart';
import '../../data/datasources/task_local_data_source.dart';
import '../../data/datasources/voice_data_source_simple.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/repositories/voice_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/voice_repository.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/process_voice_command.dart';
import '../../domain/usecases/update_task.dart';
import '../../presentation/cubits/task_cubit.dart';
import '../../presentation/cubits/voice_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => TaskCubit(
      createTask: sl(),
      getAllTasks: sl(),
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
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => GetAllTasks(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => ProcessVoiceCommand(sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      sl(),
    ),
  );

  sl.registerLazySingleton<VoiceRepository>(
    () => VoiceRepositoryImpl(
      sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<VoiceDataSourceSimple>(
    () => VoiceDataSourceSimple(),
  );
} 