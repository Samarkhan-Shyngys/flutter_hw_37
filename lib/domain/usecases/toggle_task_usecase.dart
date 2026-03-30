import '../repositories/tasks_repository.dart';

class ToggleTaskUseCase {
  final TasksRepository _repository;

  ToggleTaskUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.toggleTask(id);
  }
}
