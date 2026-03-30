import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/toggle_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';

// ViewModel — управляет состоянием UI.
// Знает о UseCases, не знает о виджетах и источниках данных.
class TasksViewModel extends ChangeNotifier {
  final GetTasksUseCase _getTasks;
  final AddTaskUseCase _addTask;
  final ToggleTaskUseCase _toggleTask;
  final DeleteTaskUseCase _deleteTask;

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

    try {
      tasks = await _getTasks();
    } catch (e) {
      errorMessage = 'Ошибка загрузки: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    try {
      await _addTask(title);
      await loadTasks();
    } on ArgumentError catch (e) {
      errorMessage = e.message.toString();
      notifyListeners();
    } catch (e) {
      errorMessage = 'Ошибка: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> toggleTask(String id) async {
    try {
      await _toggleTask(id);
      await loadTasks();
    } catch (e) {
      errorMessage = 'Ошибка: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _deleteTask(id);
      await loadTasks();
    } catch (e) {
      errorMessage = 'Ошибка: ${e.toString()}';
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
