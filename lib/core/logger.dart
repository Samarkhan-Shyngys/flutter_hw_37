// Singleton Logger — единственный экземпляр на всё приложение
class Logger {
  static final Logger _instance = Logger._internal();

  factory Logger() => _instance;

  Logger._internal();

  final List<String> _logs = [];

  List<String> get logs => List.unmodifiable(_logs);

  void log(String message) {
    final entry = '[${_timestamp()}] LOG: $message';
    _logs.add(entry);
    // ignore: avoid_print
    print(entry);
  }

  void warn(String message) {
    final entry = '[${_timestamp()}] WARN: $message';
    _logs.add(entry);
    // ignore: avoid_print
    print(entry);
  }

  void error(String message) {
    final entry = '[${_timestamp()}] ERROR: $message';
    _logs.add(entry);
    // ignore: avoid_print
    print(entry);
  }

  void clear() => _logs.clear();

  String _timestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }
}
