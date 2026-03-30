import 'package:flutter/material.dart';
import '../../core/api_response_factory.dart';
import '../../core/logger.dart';
import '../../core/analytics_service.dart';
import '../widgets/status_widget_factory.dart';

class FactoryDemoScreen extends StatefulWidget {
  const FactoryDemoScreen({super.key});

  @override
  State<FactoryDemoScreen> createState() => _FactoryDemoScreenState();
}

class _FactoryDemoScreenState extends State<FactoryDemoScreen> {
  // Место 3: Singleton используется в третьем экране
  final _logger = Logger();
  final _analytics = AnalyticsService();

  LoadStatus _currentStatus = LoadStatus.loading;
  String? _statusMessage;
  ApiResponse? _parsedResponse;

  @override
  void initState() {
    super.initState();
    _logger.log('FactoryDemoScreen открыт');
    _analytics.track('screen_view', params: {'screen': 'factory_demo'});
  }

  void _setStatus(LoadStatus status, String message) {
    setState(() {
      _currentStatus = status;
      _statusMessage = message;
    });
    _logger.log('Статус изменён: $status — $message');
  }

  void _parseApiResponse(Map<String, dynamic> json) {
    setState(() {
      _parsedResponse = ApiResponseFactory.parse(json);
    });
    _logger.log('Парсинг ответа API: type=${json['type']}');
    _analytics.track('api_response_parsed', params: {'type': json['type']});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Factory Demo', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('1. StatusWidget Factory'),
            _buildStatusButtons(),
            const SizedBox(height: 8),
            SizedBox(height: 180, child: StatusWidgetFactory.create(
              _currentStatus,
              message: _statusMessage,
              onRetry: () => _setStatus(LoadStatus.loading, 'Повторная загрузка...'),
            )),
            const SizedBox(height: 24),
            _buildSection('2. API Response Factory'),
            _buildApiButtons(),
            if (_parsedResponse != null) ...[
              const SizedBox(height: 12),
              _buildParsedResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusButtons() {
    return Wrap(
      spacing: 8,
      children: [
        ElevatedButton(
          onPressed: () => _setStatus(LoadStatus.loading, 'Загрузка данных...'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Loading'),
        ),
        ElevatedButton(
          onPressed: () => _setStatus(LoadStatus.success, 'Данные загружены!'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Success'),
        ),
        ElevatedButton(
          onPressed: () => _setStatus(LoadStatus.error, 'Нет соединения с сервером'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Error'),
        ),
      ],
    );
  }

  Widget _buildApiButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ApiButton(
          label: 'Tasks response',
          color: Colors.teal,
          onTap: () => _parseApiResponse({
            'type': 'tasks',
            'data': [
              {'id': '1', 'title': 'Task A'},
              {'id': '2', 'title': 'Task B'},
            ],
          }),
        ),
        _ApiButton(
          label: 'User response',
          color: Colors.orange,
          onTap: () => _parseApiResponse({
            'type': 'user',
            'data': {'id': 'u1', 'name': 'Shyngys'},
          }),
        ),
        _ApiButton(
          label: 'Error response',
          color: Colors.red,
          onTap: () => _parseApiResponse({
            'type': 'error',
            'code': 404,
            'message': 'Not found',
          }),
        ),
        _ApiButton(
          label: 'Unknown response',
          color: Colors.grey,
          onTap: () => _parseApiResponse({'type': 'something_new'}),
        ),
      ],
    );
  }

  Widget _buildParsedResult() {
    final r = _parsedResponse!;
    String result = '';
    Color color = Colors.white;

    if (r is TasksApiResponse) {
      result = 'TasksApiResponse: ${r.tasks.length} задач\n${r.tasks.map((t) => '  • ${t['title']}').join('\n')}';
      color = Colors.teal;
    } else if (r is UserApiResponse) {
      result = 'UserApiResponse:\n  id: ${r.id}\n  name: ${r.name}';
      color = Colors.orange;
    } else if (r is ErrorApiResponse) {
      result = 'ErrorApiResponse:\n  code: ${r.code}\n  message: ${r.message}';
      color = Colors.red;
    } else {
      result = 'UnknownApiResponse';
      color = Colors.grey;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Результат парсинга:', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(result, style: const TextStyle(color: Colors.white70, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}

class _ApiButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ApiButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
