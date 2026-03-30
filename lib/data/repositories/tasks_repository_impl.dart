import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/local_tasks_datasource.dart';
import '../models/task_model.dart';

// RepositoryImpl — реализует интерфейс из Domain.
// Работает с DataSource и конвертирует Model → Entity.
// Presentation НЕ знает об этом классе — знает только об интерфейсе.
class TasksRepositoryImpl implements TasksRepository {
  final TasksDataSource _dataSource;

  TasksRepositoryImpl(this._dataSource);

  @override
  Future<List<Task>> getTasks() async {
    final models = await _dataSource.getTasks();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    await _dataSource.addTask(model);
  }

  @override
  Future<void> toggleTask(String id) async {
    await _dataSource.toggleTask(id);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _dataSource.deleteTask(id);
  }
}
