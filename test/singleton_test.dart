import 'package:flutter_test/flutter_test.dart';
import 'package:hw37/core/logger.dart';
import 'package:hw37/core/analytics_service.dart';
import 'package:hw37/core/api_response_factory.dart';

void main() {
  group('Logger Singleton', () {
    test('возвращает один и тот же экземпляр', () {
      final logger1 = Logger();
      final logger2 = Logger();

      expect(identical(logger1, logger2), true);
    });

    test('hashCode одинаковый у всех экземпляров', () {
      final logger1 = Logger();
      final logger2 = Logger();
      final logger3 = Logger();

      expect(logger1.hashCode, equals(logger2.hashCode));
      expect(logger2.hashCode, equals(logger3.hashCode));
    });

    test('лог записывается и хранится', () {
      final logger = Logger();
      logger.clear();

      logger.log('Тест сообщения');

      expect(logger.logs.length, 1);
      expect(logger.logs.first, contains('Тест сообщения'));
    });

    test('все экземпляры видят одни и те же логи', () {
      final logger1 = Logger();
      final logger2 = Logger();
      logger1.clear();

      logger1.log('Сообщение от logger1');

      // logger2 видит тот же лог — это один объект
      expect(logger2.logs.length, 1);
      expect(logger2.logs.first, contains('Сообщение от logger1'));
    });

    test('warn и error добавляются в логи', () {
      final logger = Logger();
      logger.clear();

      logger.warn('Предупреждение');
      logger.error('Ошибка');

      expect(logger.logs.length, 2);
      expect(logger.logs[0], contains('WARN'));
      expect(logger.logs[1], contains('ERROR'));
    });
  });

  group('AnalyticsService Singleton', () {
    test('возвращает один и тот же экземпляр', () {
      final analytics1 = AnalyticsService();
      final analytics2 = AnalyticsService();

      expect(identical(analytics1, analytics2), true);
    });

    test('события записываются и видны из любого экземпляра', () {
      final analytics1 = AnalyticsService();
      final analytics2 = AnalyticsService();
      analytics1.clear();

      analytics1.track('test_event', params: {'key': 'value'});

      expect(analytics2.events.length, 1);
      expect(analytics2.events.first.name, 'test_event');
      expect(analytics2.events.first.params['key'], 'value');
    });

    test('не создаётся новый объект при повторном вызове', () {
      final instances = List.generate(10, (_) => AnalyticsService());

      for (final instance in instances) {
        expect(identical(instance, instances.first), true);
      }
    });
  });

  group('ApiResponseFactory', () {
    test('парсит tasks ответ', () {
      final json = {
        'type': 'tasks',
        'data': [
          {'id': '1', 'title': 'Task A'},
          {'id': '2', 'title': 'Task B'},
        ],
      };

      final response = ApiResponseFactory.parse(json);

      expect(response, isA<TasksApiResponse>());
      expect((response as TasksApiResponse).tasks.length, 2);
    });

    test('парсит user ответ', () {
      final json = {
        'type': 'user',
        'data': {'id': 'u1', 'name': 'Shyngys'},
      };

      final response = ApiResponseFactory.parse(json);

      expect(response, isA<UserApiResponse>());
      expect((response as UserApiResponse).name, 'Shyngys');
    });

    test('парсит error ответ', () {
      final json = {'type': 'error', 'code': 404, 'message': 'Not found'};

      final response = ApiResponseFactory.parse(json);

      expect(response, isA<ErrorApiResponse>());
      expect((response as ErrorApiResponse).code, 404);
    });

    test('возвращает UnknownApiResponse для неизвестного типа', () {
      final json = {'type': 'something_unknown'};

      final response = ApiResponseFactory.parse(json);

      expect(response, isA<UnknownApiResponse>());
    });

    test('возвращает UnknownApiResponse если type отсутствует', () {
      final json = {'data': 'some data'};

      final response = ApiResponseFactory.parse(json);

      expect(response, isA<UnknownApiResponse>());
    });
  });
}
