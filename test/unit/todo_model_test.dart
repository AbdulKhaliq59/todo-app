import 'package:flutter_test/flutter_test.dart';
import 'package:todo/domain/models/todo_model.dart';

void main() {
  group('TodoModel', () {
    final now = DateTime.now();
    final todo = TodoModel(
      id: '123',
      title: 'Test Title',
      description: 'Test Description',
      isDone: false,
      createdAt: now,
    );

    test('should create a valid TodoModel', () {
      expect(todo.id, '123');
      expect(todo.title, 'Test Title');
      expect(todo.description, 'Test Description');
      expect(todo.isDone, false);
      expect(todo.createdAt, now);
    });

    test('should create a TodoModel using the create factory', () {
      final created = TodoModel.create(title: 'New', description: 'Desc');
      expect(created.title, 'New');
      expect(created.description, 'Desc');
      expect(created.isDone, false);
      expect(created.id, isNotNull);
      expect(created.createdAt, isA<DateTime>());
    });

    test('copyWith should update fields', () {
      final updated = todo.copyWith(title: 'Updated', isDone: true);
      expect(updated.id, todo.id);
      expect(updated.title, 'Updated');
      expect(updated.description, todo.description);
      expect(updated.isDone, true);
      expect(updated.createdAt, todo.createdAt);
    });

    test('toMap should return correct map', () {
      final map = todo.toMap();
      expect(map['id'], '123');
      expect(map['title'], 'Test Title');
      expect(map['description'], 'Test Description');
      expect(map['isDone'], 0);
      expect(map['createdAt'], now.toIso8601String());
    });

    test('toJson should return correct map', () {
      final json = todo.toJson();
      expect(json['id'], '123');
      expect(json['title'], 'Test Title');
      expect(json['description'], 'Test Description');
      expect(json['isDone'], 0);
      expect(json['createdAt'], now.toIso8601String());
    });

    test('fromMap should create correct TodoModel', () {
      final map = {
        'id': 'abc',
        'title': 'FromMap',
        'description': 'FromMapDesc',
        'isDone': 1,
        'createdAt': now.toIso8601String(),
      };
      final fromMap = TodoModel.fromMap(map);
      expect(fromMap.id, 'abc');
      expect(fromMap.title, 'FromMap');
      expect(fromMap.description, 'FromMapDesc');
      expect(fromMap.isDone, true);
      expect(fromMap.createdAt, now);
    });

    test('props should contain all fields', () {
      expect(todo.props, [
        todo.id,
        todo.title,
        todo.description,
        todo.isDone,
        todo.createdAt,
      ]);
    });

    test('equality should work as expected', () {
      final todo2 = TodoModel(
        id: '123',
        title: 'Test Title',
        description: 'Test Description',
        isDone: false,
        createdAt: now,
      );
      expect(todo, equals(todo2));
    });
  });
}
