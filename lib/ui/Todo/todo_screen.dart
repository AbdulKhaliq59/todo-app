import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/ui/Todo/viewModel/todo_viewmodel.dart';
// import '../../domain/models/todo_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to ensure context is available and avoid async gap issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TodoViewmodel>().loadTodos();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTodo(BuildContext context) {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      context.read<TodoViewmodel>().addTodo(title, description);
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) { 
    final viewModel = context.watch<TodoViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Todo Manager'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _addTodo(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Add Todo'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (viewModel.isLoading)
              const CircularProgressIndicator()
            else if (viewModel.todos.isEmpty)
              const Text('No todos yet. Start by adding one.')
            else
              Expanded(
                child: ListView.separated(
                  itemCount: viewModel.todos.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, index) {
                    final todo = viewModel.todos[index];
                    return Dismissible(
                      key: ValueKey(todo.id),
                      background: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => viewModel.deleteTodo(todo.id),
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            todo.isDone
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: todo.isDone ? Colors.green : Colors.grey,
                          ),
                          onPressed: () => viewModel.toggleComplete(todo),
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration:
                                todo.isDone ? TextDecoration.lineThrough : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(todo.description),
                        trailing: Text(
                          '${todo.createdAt.day}/${todo.createdAt.month}/${todo.createdAt.year}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
