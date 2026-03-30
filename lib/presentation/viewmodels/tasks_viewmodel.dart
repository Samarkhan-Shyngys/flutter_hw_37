import 'package:flutter/material.dart';
import '../../core/logger.dart';
import '../../core/analytics_service.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/toggle_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';

class TasksViewModel extends ChangeNotifier {
  final GetTasksUseCase _getTasks;
  final AddTaskUseCase _addTask;
  final ToggleTaskUseCase _toggleTask;
  final DeleteTaskUseCase _deleteTask;

  // Место 1: Singleton используется в ViewModel
  final _logger = Logger();
  final _analytics = AnalyticsService();

  TasksViewModel(
    this._getTasks,
    this._addTask,
    this._toggleTask,
    this._deleteTask,
  );

  List<Task> tasks = [];
  bool isLoading = false;
  String? errorMessage;

  int get completedCount => tasks.where((t) => t.isCompleted).length;
  int get pendingCount => tasks.where((t) => !t.isCompleted).length;

  Future<void> loadTasks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    _logger.log('Загрузка задач...');

    try {
      tasks = await _getTasks();
      _logger.log('Загружено задач: ${tasks.length}');
      _analytics.track('tasks_loaded', params: {'count': tasks.length});
    } catch (e) {
      errorMessage = 'Ошибка загрузки: ${e.toString()}';
      _logger.error('Ошибка загрузки задач: $e');
      _analytics.track('tasks_load_error', params: {'error': e.toString()});
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    try {
      await _addTask(title);
      _logger.log('Задача добавлена: "$title"');
      _analytics.track('task_added', params: {'title': title});
      await loadTasks();
    } on ArgumentError catch (e) {
      errorMessage = e.message.toString();
      _logger.warn('Невалидный заголовок: $title');
      notifyListeners();
    } catch (e) {
      errorMessage = 'Ошибка: ${e.toString()}';
      _logger.error('Ошибка добавления задачи: $e');
      notifyListeners();
    }
  }

  Future<void> toggleTask(String id) async {
    try {
      await _toggleTask(id);
      _logger.log('Статус задачи изменён: $id');
      _analytics.track('task_toggled', params: {'id': id});
      await loadTasks();
    } catch (e) {
      errorMessage = 'Ошибка: ${e.toString()}';
      _logger.error('Ошибка переключения задачи: $e');
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _deleteTask(id);
      _logger.log('Задача удалена: $id');
      _analytics.track('task_deleted', params: {'id': id});
      await loadTasks();
    } catch (e) {
      errorMessage = 'Ошибка: ${e.toString()}';
      _logger.error('Ошибка удаления задачи: $e');
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
