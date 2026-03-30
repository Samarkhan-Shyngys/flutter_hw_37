import 'package:flutter/material.dart';
import '../../core/logger.dart';
import '../../core/analytics_service.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  static const _points = [
    _ComparisonPoint(
      number: 1,
      title: 'Тестируемость',
      singleton: 'Сложно — состояние разделяется между тестами, нельзя легко заменить на mock',
      di: 'Просто — внедряем mock через конструктор, тесты полностью изолированы',
      diWins: true,
    ),
    _ComparisonPoint(
      number: 2,
      title: 'Простота использования',
      singleton: 'Просто — `Logger()` везде, не нужно передавать зависимость',
      di: 'Сложнее — нужно зарегистрировать и получить через getIt<Logger>()',
      diWins: false,
    ),
    _ComparisonPoint(
      number: 3,
      title: 'Инкапсуляция',
      singleton: 'Нарушена — любой класс может получить доступ без явного объявления зависимости',
      di: 'Соблюдена — зависимости явно объявлены в конструкторе каждого класса',
      diWins: true,
    ),
    _ComparisonPoint(
      number: 4,
      title: 'Гибкость замены',
      singleton: 'Жёстко — реализация вшита, заменить без изменения кода невозможно',
      di: 'Гибко — можно зарегистрировать другую реализацию в Composition Root',
      diWins: true,
    ),
    _ComparisonPoint(
      number: 5,
      title: 'Жизненный цикл',
      singleton: 'Живёт всё время приложения, нельзя контролировать когда создаётся',
      di: 'Полный контроль — Singleton, Factory, или Scoped по необходимости',
      diWins: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Логирование открытия экрана
    Logger().log('ComparisonScreen открыт');
    AnalyticsService().track('screen_view', params: {'screen': 'comparison'});

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Singleton vs DI', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          ..._points.map((p) => _buildPoint(p)),
          const SizedBox(height: 16),
          _buildConclusion(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text('Singleton', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Text('vs', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text('DI (get_it)', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildPoint(_ComparisonPoint point) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: point.diWins ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.deepPurple,
                child: Text('${point.number}', style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Text(point.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              Icon(point.diWins ? Icons.thumb_up : Icons.thumb_down,
                  color: point.diWins ? Colors.green : Colors.orange, size: 18),
              const SizedBox(width: 4),
              Text(point.diWins ? 'DI лучше' : 'Singleton проще',
                  style: TextStyle(color: point.diWins ? Colors.green : Colors.orange, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SideBox(
                  label: 'Singleton',
                  text: point.singleton,
                  color: Colors.orange,
                  isWinner: !point.diWins,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SideBox(
                  label: 'DI',
                  text: point.di,
                  color: Colors.green,
                  isWinner: point.diWins,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConclusion() {
    final diWins = _points.where((p) => p.diWins).length;
    final singletonWins = _points.length - diWins;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple),
      ),
      child: Column(
        children: [
          const Text('Вывод', style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            'DI (get_it): $diWins/5  •  Singleton: $singletonWins/5',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          const Text(
            'Singleton подходит для простых утилит (Logger, Cache). '
            'DI предпочтителен для бизнес-логики — он тестируемый, гибкий и явный.',
            style: TextStyle(color: Colors.white54, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SideBox extends StatelessWidget {
  final String label;
  final String text;
  final Color color;
  final bool isWinner;
  const _SideBox({required this.label, required this.text, required this.color, required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isWinner ? color.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ComparisonPoint {
  final int number;
  final String title;
  final String singleton;
  final String di;
  final bool diWins;
  const _ComparisonPoint({
    required this.number,
    required this.title,
    required this.singleton,
    required this.di,
    required this.diWins,
  });
}
