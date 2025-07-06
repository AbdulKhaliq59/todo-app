import 'package:todo/data/services/todo_service.dart';
import 'package:todo/domain/models/todo_model.dart';

abstract class ITodoRepository {
  Future<void> addTodo(TodoModel todo);
  Future<List<TodoModel>> getTodos();
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

class TodoRepository implements ITodoRepository {
  final TodoService _service;

  TodoRepository(this._service);

  @override
  Future<void> addTodo(TodoModel todo) async {
    await _service.insertTodo(todo);
  }

  @override
  Future<List<TodoModel>> getTodos() async {
    return await _service.fetchTodos();
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await _service.updateTodo(todo);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _service.deleteTodo(id);
  }
}
