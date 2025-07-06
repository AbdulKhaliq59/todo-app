import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/ui/Todo/todo_screen.dart';
import 'package:todo/ui/Todo/viewModel/todo_viewmodel.dart';
import 'data/services/todo_service.dart';
import 'data/repositories/todo_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => TodoService()),
        ProxyProvider<TodoService, TodoRepository>(
          update: (_, service, __) => TodoRepository(service),
        ),
        ChangeNotifierProvider<TodoViewmodel>(
          create:
              (context) =>
                  TodoViewmodel(repository: context.read<TodoRepository>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Todo CI/CD',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),
        home: const TodoScreen(),
      ),
    );
  }
}

