import 'package:get_it/get_it.dart';
import 'data/datasources/local_tasks_datasource.dart';
import 'data/repositories/tasks_repository_impl.dart';
import 'domain/repositories/tasks_repository.dart';
import 'domain/usecases/get_tasks_usecase.dart';
import 'domain/usecases/add_task_usecase.dart';
import 'domain/usecases/toggle_task_usecase.dart';
import 'domain/usecases/delete_task_usecase.dart';
import 'presentation/viewmodels/tasks_viewmodel.dart';

// Composition Root — все зависимости регистрируются в одном месте
final getIt = GetIt.instance;

void setupDependencies() {
  // Data Sources — singleton, создаётся один раз
  getIt.registerLazySingleton<TasksDataSource>(
    () => LocalTasksDataSource(),
  );

  // Repositories — singleton
  getIt.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(getIt()),
  );

  // UseCases — factory, новый объект при каждом запросе
  getIt.registerFactory(() => GetTasksUseCase(getIt()));
  getIt.registerFactory(() => AddTaskUseCase(getIt()));
  getIt.registerFactory(() => ToggleTaskUseCase(getIt()));
  getIt.registerFactory(() => DeleteTaskUseCase(getIt()));

  // ViewModels — factory
  getIt.registerFactory(
    () => TasksViewModel(getIt(), getIt(), getIt(), getIt()),
  );
}
