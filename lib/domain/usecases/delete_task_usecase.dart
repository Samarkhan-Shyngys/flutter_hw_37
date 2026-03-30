import '../repositories/tasks_repository.dart';

class DeleteTaskUseCase {
  final TasksRepository _repository;

  DeleteTaskUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.deleteTask(id);
  }
}
