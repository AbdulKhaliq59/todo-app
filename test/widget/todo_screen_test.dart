import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/ui/Todo/todo_screen.dart';
import 'package:todo/ui/Todo/viewModel/todo_viewmodel.dart';
import 'package:todo/domain/models/todo_model.dart';

@GenerateMocks([TodoViewmodel])
import 'todo_screen_test.mocks.dart';

void main() {
  group('TodoScreen Widget Test', () {
    late MockTodoViewmodel mockViewmodel;

    setUp(() {
      mockViewmodel = MockTodoViewmodel();
      when(mockViewmodel.isLoading).thenReturn(false);
      when(mockViewmodel.todos).thenReturn([]);
    });

    Widget createWidgetUnderTest() {
      return ChangeNotifierProvider<TodoViewmodel>.value(
        value: mockViewmodel,
        child: const MaterialApp(home: TodoScreen()),
      );
    }

    testWidgets('displays empty state when no todos', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('No todos yet. Start by adding one.'), findsOneWidget);
    });

    testWidgets('displays todos in the list', (WidgetTester tester) async {
      final todo = TodoModel(
        id: '1',
        title: 'Test Todo',
        description: 'desc',
        isDone: false,
        createdAt: DateTime(2024, 7, 7),
      );
      when(mockViewmodel.todos).thenReturn([todo]);
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Test Todo'), findsOneWidget);
      expect(find.text('desc'), findsOneWidget);
      expect(find.text('7/7/2024'), findsOneWidget);
    });

    testWidgets('calls addTodo when Add Todo button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextField).at(0), 'New Todo');
      await tester.enterText(find.byType(TextField).at(1), 'New Desc');
      await tester.tap(find.text('Add Todo'));
      await tester.pump();
      verify(mockViewmodel.addTodo('New Todo', 'New Desc')).called(1);
    });
  });
}
