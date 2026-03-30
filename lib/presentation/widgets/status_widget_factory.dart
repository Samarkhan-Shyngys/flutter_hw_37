import 'package:flutter/material.dart';

// Enum для статуса
enum LoadStatus { loading, success, error }

// Factory для создания виджетов статуса по enum
class StatusWidgetFactory {
  static Widget create(
    LoadStatus status, {
    String? message,
    VoidCallback? onRetry,
  }) {
    switch (status) {
      case LoadStatus.loading:
        return _LoadingWidget(message: message);
      case LoadStatus.success:
        return _SuccessWidget(message: message);
      case LoadStatus.error:
        return _ErrorWidget(message: message, onRetry: onRetry);
    }
  }
}

class _LoadingWidget extends StatelessWidget {
  final String? message;
  const _LoadingWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.blue),
          const SizedBox(height: 16),
          Text(
            message ?? 'Загрузка...',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  final String? message;
  const _SuccessWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          Text(
            message ?? 'Успешно!',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  const _ErrorWidget({this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            message ?? 'Произошла ошибка',
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}
