import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class AddTaskUseCase {
  final TasksRepository _repository;

  AddTaskUseCase(this._repository);

  Future<void> call(String title) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Название задачи не может быть пустым');
    }
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      createdAt: DateTime.now(),
    );
    return _repository.addTask(task);
  }
}
