import 'package:taskflow/features/todo/model/todo_priority.dart';

class TodoModel {
  final int? id;
  final String todo;
  final String? description;
  final bool isCompleted;
  final String? category;
  final TodoPriority priority;
  final DateTime? dueDate;
  final DateTime? reminderDate;
  final DateTime createdAt;

    TodoModel({
    this.id,
    required this.todo,
    this.description,
    this.isCompleted = false,
    this.category,
    this.dueDate,
    this.reminderDate,
    this.priority = TodoPriority.low,
    required this.createdAt,
  });
}
