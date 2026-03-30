import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

// UseCase: один сценарий = один класс
// Dart позволяет вызывать объект как функцию через метод call()
class GetTasksUseCase {
  final TasksRepository _repository;

  GetTasksUseCase(this._repository);

  Future<List<Task>> call() {
    return _repository.getTasks();
  }
}
