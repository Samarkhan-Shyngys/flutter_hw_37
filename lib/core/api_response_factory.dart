// Фабрика для парсинга ответов API по типу

enum ApiResponseType { tasks, user, error, unknown }

// Базовый класс ответа
abstract class ApiResponse {
  final ApiResponseType type;
  const ApiResponse(this.type);
}

// Конкретные ответы
class TasksApiResponse extends ApiResponse {
  final List<Map<String, dynamic>> tasks;
  const TasksApiResponse(this.tasks) : super(ApiResponseType.tasks);
}

class UserApiResponse extends ApiResponse {
  final String id;
  final String name;
  const UserApiResponse({required this.id, required this.name})
      : super(ApiResponseType.user);
}

class ErrorApiResponse extends ApiResponse {
  final int code;
  final String message;
  const ErrorApiResponse({required this.code, required this.message})
      : super(ApiResponseType.error);
}

class UnknownApiResponse extends ApiResponse {
  const UnknownApiResponse() : super(ApiResponseType.unknown);
}

// Factory — парсит JSON и возвращает нужный тип
class ApiResponseFactory {
  static ApiResponse parse(Map<String, dynamic> json) {
    final type = json['type'] as String?;

    switch (type) {
      case 'tasks':
        final rawList = json['data'] as List? ?? [];
        final tasks = rawList.cast<Map<String, dynamic>>();
        return TasksApiResponse(tasks);

      case 'user':
        return UserApiResponse(
          id: json['data']['id'] as String,
          name: json['data']['name'] as String,
        );

      case 'error':
        return ErrorApiResponse(
          code: json['code'] as int? ?? 0,
          message: json['message'] as String? ?? 'Unknown error',
        );

      default:
        return const UnknownApiResponse();
    }
  }
}
