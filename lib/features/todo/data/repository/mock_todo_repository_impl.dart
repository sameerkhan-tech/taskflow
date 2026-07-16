import 'package:taskflow/features/todo/data/repository/todo_repository.dart';
import 'package:taskflow/features/todo/model/todo_model.dart';
import 'package:taskflow/features/todo/model/todo_priority.dart';

class MockTodoRepositoryImpl implements TodoRepository {
  @override
  Future<List<TodoModel>> fetchTodos() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      TodoModel(
        id: 1,
        todo: 'Task 1.Complete the taskflow app',
        category: 'Flutter',
        createdAt: DateTime(2026, 7, 15, 17),
        dueDate: DateTime(2026, 7, 18),
        reminderDate: DateTime(2026, 7, 16),
        priority: TodoPriority.urgent,
      ),
      TodoModel(
        id: 2,
        todo: 'Task 2.Practice English for 1 hour',
        category: 'English',
        createdAt: DateTime(2026, 7, 15, 14),
        dueDate: DateTime(2026, 7, 14),
        reminderDate: DateTime(2026, 7, 14, 18),
        priority: TodoPriority.high,
      ),
      TodoModel(
        id: 3,
        todo: 'Task 3.Train Legs',
        category: 'Fitness',
        createdAt: DateTime(2026, 7, 16, 17),
        dueDate: DateTime(2026, 7, 16),
        priority: TodoPriority.medium,
      ),
      TodoModel(
        id: 4,
        todo: 'Task 4.Buy t-shirt',
        category: 'Shopping',
        createdAt: DateTime(2026, 7, 16, 17),
        dueDate: DateTime(2026, 8, 1),
        reminderDate: DateTime(2026, 7, 30),
        priority: TodoPriority.low,
      ),
    ];
  }
}
