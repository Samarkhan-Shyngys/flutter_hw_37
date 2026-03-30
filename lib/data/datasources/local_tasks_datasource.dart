import '../models/task_model.dart';

// DataSource — прямая работа с источником данных.
// Здесь используется in-memory хранилище.
// В реальном проекте здесь был бы Firestore, REST API, или SQLite.
abstract class TasksDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> toggleTask(String id);
  Future<void> deleteTask(String id);
}

class LocalTasksDataSource implements TasksDataSource {
  final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'Изучить Clean Architecture',
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch,
    ),
    TaskModel(
      id: '2',
      title: 'Реализовать MVVM паттерн',
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
    ),
    TaskModel(
      id: '3',
      title: 'Настроить get_it для DI',
      isCompleted: true,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ),
  ];

  @override
  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_tasks);
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _tasks.add(task);
  }

  @override
  Future<void> toggleTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) throw ArgumentError('Задача не найдена: $id');
    final t = _tasks[index];
    _tasks[index] = TaskModel(
      id: t.id,
      title: t.title,
      isCompleted: !t.isCompleted,
      createdAt: t.createdAt,
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
  }
}
