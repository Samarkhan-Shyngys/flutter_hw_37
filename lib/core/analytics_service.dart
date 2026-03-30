// Singleton AnalyticsService — отслеживает события по всему приложению
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() => _instance;

  AnalyticsService._internal();

  final List<AnalyticsEvent> _events = [];

  List<AnalyticsEvent> get events => List.unmodifiable(_events);

  void track(String name, {Map<String, dynamic>? params}) {
    final event = AnalyticsEvent(
      name: name,
      params: params ?? {},
      timestamp: DateTime.now(),
    );
    _events.add(event);
    // ignore: avoid_print
    print('[Analytics] $name ${params ?? ''}');
  }

  void clear() => _events.clear();
}

class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> params;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.name,
    required this.params,
    required this.timestamp,
  });

  @override
  String toString() => '[${timestamp.toIso8601String()}] $name $params';
}
