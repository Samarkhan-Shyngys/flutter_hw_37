import '../entities/task.dart';

// Repository Interface — контракт в Domain слое.
// Domain знает только этот интерфейс, не зная о реализации (Firebase, API, Local DB)
abstract class TasksRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> toggleTask(String id);
  Future<void> deleteTask(String id);
}
