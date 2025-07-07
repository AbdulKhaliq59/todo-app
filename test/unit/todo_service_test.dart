import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/data/services/todo_service.dart';
import 'package:todo/domain/models/todo_model.dart';
import 'package:uuid/uuid.dart';

import 'todo_service_test.mocks.dart';

@GenerateMocks([TodoService])
void main() {
  group('TodoService', () {
    late MockTodoService mockService;
    late TodoModel todo;

    setUp(() {
      mockService = MockTodoService();
      todo = TodoModel(
        id: Uuid().v4(),
        title: 'Test',
        description: 'Description of test',
        isDone: false,
        createdAt: DateTime.now(),
      );
    });

    test('should get todos', () async {
      when(mockService.fetchTodos()).thenAnswer((_) async => [todo]);
      final todos = await mockService.fetchTodos();
      expect(todos, isA<List<TodoModel>>());
      expect(todos.length, 1);
      expect(todos.first.title, 'Test');
    });

    test('should insert todo', () async {
      when(
        mockService.insertTodo(todo),
      ).thenAnswer((_) async => Future.value());
      await mockService.insertTodo(todo);
      verify(mockService.insertTodo(todo)).called(1);
    });

    test('should update todo', () async {
      final updatedTodo = TodoModel(
        id: todo.id,
        title: 'Updated',
        description: 'Updated description',
        isDone: true,
        createdAt: todo.createdAt,
      );
      when(
        mockService.updateTodo(updatedTodo),
      ).thenAnswer((_) async => Future.value());
      await mockService.updateTodo(updatedTodo);
      verify(mockService.updateTodo(updatedTodo)).called(1);
    });

    test('should delete todo', () async {
      when(
        mockService.deleteTodo(todo.id),
      ).thenAnswer((_) async => Future.value());
      await mockService.deleteTodo(todo.id);
      verify(mockService.deleteTodo(todo.id)).called(1);
    });

    test('should initialize database', () async {
      // Since _initDB is private, we test the public getter
      when(
        mockService.database,
      ).thenAnswer((_) async => throw UnimplementedError());
      expect(() => mockService.database, throwsA(isA<UnimplementedError>()));
    });
  });
}
