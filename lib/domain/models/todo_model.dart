import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class TodoModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isDone;
  final DateTime createdAt;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
    required this.createdAt,
  });

  factory TodoModel.create({
    required String title,
    required String description,
  }) {
    return TodoModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      isDone: false,
      createdAt: DateTime.now(),
    );
  }

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: (map['isDone']) == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  List<Object?> get props => [id, title, description, isDone, createdAt];
}
