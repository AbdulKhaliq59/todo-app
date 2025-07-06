import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/data/repositories/todo_repository.dart';
import 'package:todo/data/services/todo_service.dart';
import 'package:todo/domain/models/todo_model.dart';
import 'package:uuid/uuid.dart';

import 'todo_service_test.mocks.dart';

@GenerateMocks([TodoService])
void main() {
  group('TodoRepository', () {
    late MockTodoService mockService;
    late TodoRepository repository;
    late TodoModel testTodo;

    setUp(() {
      mockService = MockTodoService();
      repository = TodoRepository(mockService);
      testTodo = TodoModel(
        id: Uuid().v4(),
        title: 'Test',
        description: 'Test description',
        isDone: false,
        createdAt: DateTime.now(),
      );
    });

    test('should add a todo', () async {
      when(mockService.insertTodo(any)).thenAnswer((_) async => {});
      await repository.addTodo(testTodo);
      verify(mockService.insertTodo(testTodo)).called(1);
    });

    test('should fetch todos', () async {
      when(mockService.fetchTodos()).thenAnswer((_) async => [testTodo]);
      final todos = await repository.getTodos();
      expect(todos, isA<List<TodoModel>>());
      expect(todos.first.title, 'Test');
      verify(mockService.fetchTodos()).called(1);
    });

    test('should update a todo', () async {
      when(mockService.updateTodo(any)).thenAnswer((_) async => {});
      await repository.updateTodo(testTodo);
      verify(mockService.updateTodo(testTodo)).called(1);
    });

    test('should delete a todo', () async {
      when(mockService.deleteTodo(any)).thenAnswer((_) async => {});
      await repository.deleteTodo(testTodo.id);
      verify(mockService.deleteTodo(testTodo.id)).called(1);
    });
  });
}
