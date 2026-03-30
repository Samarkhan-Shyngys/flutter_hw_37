import 'package:flutter/material.dart';
import '../../core/logger.dart';
import '../../core/analytics_service.dart';
import '../../domain/entities/task.dart';
import '../../presentation/widgets/status_widget_factory.dart';
import '../viewmodels/tasks_viewmodel.dart';

class TasksScreen extends StatefulWidget {
  final TasksViewModel viewModel;
  const TasksScreen({super.key, required this.viewModel});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _textController = TextEditingController();

  // Место 2: Singleton используется в View
  final _logger = Logger();
  final _analytics = AnalyticsService();

  TasksViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _logger.log('TasksScreen открыт');
    _analytics.track('screen_view', params: {'screen': 'tasks'});
    _vm.addListener(_onUpdate);
    _vm.loadTasks();
  }

  void _onUpdate() {
    setState(() {});
    if (_vm.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_vm.errorMessage!),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: _vm.clearError,
              ),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _logger.log('TasksScreen закрыт');
    _vm.removeListener(_onUpdate);
    _textController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _textController.clear();
    _analytics.track('add_dialog_opened');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Новая задача', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _textController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Введите название...',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (_) => _submit(ctx),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => _submit(ctx),
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext ctx) async {
    Navigator.pop(ctx);
    await _vm.addTask(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Tasks — Singleton & Factory', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _vm.loadTasks,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    // Место использования StatusWidgetFactory (Factory pattern)
    if (_vm.isLoading) {
      return StatusWidgetFactory.create(
        LoadStatus.loading,
        message: 'Загрузка задач...',
      );
    }

    if (_vm.errorMessage != null && _vm.tasks.isEmpty) {
      return StatusWidgetFactory.create(
        LoadStatus.error,
        message: _vm.errorMessage,
        onRetry: _vm.loadTasks,
      );
    }

    if (_vm.tasks.isEmpty) {
      return StatusWidgetFactory.create(
        LoadStatus.success,
        message: 'Нет задач. Нажмите + чтобы добавить',
      );
    }

    return Column(
      children: [
        _buildStats(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: _vm.tasks.length,
            itemBuilder: (ctx, i) => _buildTaskItem(_vm.tasks[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Container(
      color: const Color(0xFF161B22),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatChip(label: 'Всего', value: _vm.tasks.length, color: Colors.blue),
          _StatChip(label: 'Готово', value: _vm.completedCount, color: Colors.green),
          _StatChip(label: 'Осталось', value: _vm.pendingCount, color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _vm.deleteTask(task.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => _vm.toggleTask(task.id),
            activeColor: Colors.deepPurple,
          ),
          title: Text(
            task.title,
            style: TextStyle(
              color: task.isCompleted ? Colors.grey : Colors.white,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            _formatDate(task.createdAt),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: task.isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
