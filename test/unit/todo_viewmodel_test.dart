import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/ui/Todo/viewModel/todo_viewmodel.dart';
import 'package:todo/data/repositories/todo_repository.dart';
import 'package:todo/domain/models/todo_model.dart';

import 'todo_viewmodel_test.mocks.dart';

@GenerateMocks([ITodoRepository])
void main() {
  group('TodoViewmodel', () {
    late MockITodoRepository mockRepository;
    late TodoViewmodel viewModel;

    setUp(() {
      mockRepository = MockITodoRepository();
      viewModel = TodoViewmodel(repository: mockRepository);
    });

    test('should load todos', () async {
      final todos = [
        TodoModel(
          id: '1',
          title: 'Test',
          description: 'desc',
          isDone: false,
          createdAt: DateTime.now(),
        ),
      ];
      when(mockRepository.getTodos()).thenAnswer((_) async => todos);

      await viewModel.loadTodos();

      expect(viewModel.todos, todos);
      expect(viewModel.isLoading, false);
      verify(mockRepository.getTodos()).called(1);
    });

    test('should add todo and reload todos', () async {
      final todos = [
        TodoModel(
          id: '1',
          title: 'Test',
          description: 'desc',
          isDone: false,
          createdAt: DateTime.now(),
        ),
      ];
      when(mockRepository.addTodo(any)).thenAnswer((_) async => {});
      when(mockRepository.getTodos()).thenAnswer((_) async => todos);

      await viewModel.addTodo('Test', 'desc');

      verify(mockRepository.addTodo(any)).called(1);
      verify(mockRepository.getTodos()).called(1);
      expect(viewModel.todos, todos);
    });

    test('should toggle complete and reload todos', () async {
      final todo = TodoModel(
        id: '1',
        title: 'Test',
        description: 'desc',
        isDone: false,
        createdAt: DateTime.now(),
      );
      final updatedTodo = todo.copyWith(isDone: true);
      final todos = [updatedTodo];

      when(mockRepository.updateTodo(any)).thenAnswer((_) async => {});
      when(mockRepository.getTodos()).thenAnswer((_) async => todos);

      await viewModel.toggleComplete(todo);

      verify(
        mockRepository.updateTodo(
          argThat(predicate<TodoModel>((t) => t.isDone == true)),
        ),
      ).called(1);
      verify(mockRepository.getTodos()).called(1);
      expect(viewModel.todos, todos);
    });

    test('should delete todo and reload todos', () async {
      when(mockRepository.deleteTodo('1')).thenAnswer((_) async => {});
      when(mockRepository.getTodos()).thenAnswer((_) async => []);

      await viewModel.deleteTodo('1');

      verify(mockRepository.deleteTodo('1')).called(1);
      verify(mockRepository.getTodos()).called(1);
      expect(viewModel.todos, []);
    });

    test('should set isLoading true while loading', () async {
      final todos = [
        TodoModel(
          id: '1',
          title: 'Test',
          description: 'desc',
          isDone: false,
          createdAt: DateTime.now(),
        ),
      ];
      when(mockRepository.getTodos()).thenAnswer((_) async {
        expect(viewModel.isLoading, true);
        return todos;
      });

      await viewModel.loadTodos();

      expect(viewModel.isLoading, false);
    });
  });
}
