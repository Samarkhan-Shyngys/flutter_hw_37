import 'package:flutter/material.dart';
import 'core/logger.dart';
import 'core/analytics_service.dart';
import 'injection.dart';
import 'presentation/screens/tasks_screen.dart';
import 'presentation/screens/factory_demo_screen.dart';
import 'presentation/screens/comparison_screen.dart';

void main() {
  // Место использования Singleton при старте приложения
  Logger().log('Приложение запущено');
  AnalyticsService().track('app_start');

  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HW37 — Singleton & Factory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('День 38', textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 8),
              const Text('Singleton & Factory',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Паттерны проектирования',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 15)),
              const SizedBox(height: 48),
              _NavButton(
                label: 'Tasks (Singleton Logger)',
                description: 'Logger и Analytics используются в 3 местах',
                icon: Icons.checklist_rounded,
                color: Colors.blue,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => TasksScreen(viewModel: getIt()))),
              ),
              const SizedBox(height: 16),
              _NavButton(
                label: 'Factory Demo',
                description: 'StatusWidget Factory + API Response Factory',
                icon: Icons.factory_rounded,
                color: Colors.teal,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FactoryDemoScreen())),
              ),
              const SizedBox(height: 16),
              _NavButton(
                label: 'Singleton vs DI',
                description: '5 пунктов сравнения с плюсами и минусами',
                icon: Icons.compare_arrows_rounded,
                color: Colors.deepPurple,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ComparisonScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}
