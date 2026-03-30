import '../../domain/entities/task.dart';

// Model — Data слой. Знает о сериализации JSON, Firebase, etc.
// Конвертируется в Entity для Domain слоя
class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final int createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      createdAt: json['createdAt'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'createdAt': createdAt,
      };

  // Конвертация Model → Entity (Domain)
  Task toEntity() => Task(
        id: id,
        title: title,
        isCompleted: isCompleted,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      );

  // Конвертация Entity → Model
  factory TaskModel.fromEntity(Task task) => TaskModel(
        id: task.id,
        title: task.title,
        isCompleted: task.isCompleted,
        createdAt: task.createdAt.millisecondsSinceEpoch,
      );
}
