import 'package:flutter/material.dart';
import 'package:todo/data/repositories/todo_repository.dart';
import 'package:todo/domain/models/todo_model.dart';

class TodoViewmodel extends ChangeNotifier {
  final ITodoRepository repository;

  List<TodoModel> todos = [];
  bool isLoading = false;

  TodoViewmodel({required this.repository});

  Future<void> loadTodos() async {
    _setIsLoading(true);
    todos = await repository.getTodos();
    _setIsLoading(false);
  }

  Future<void> addTodo(String title, String description) async {
    final todo = TodoModel.create(title: title, description: description);
    await repository.addTodo(todo);
    await loadTodos();
  }

  Future<void> toggleComplete(TodoModel todo) async {
    final updatedTodo = todo.copyWith(isDone: !todo.isDone);
    await repository.updateTodo(updatedTodo);
    await loadTodos();
  }

  Future<void> deleteTodo(String id) async {
    await repository.deleteTodo(id);
    await loadTodos();
  }

  void _setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
