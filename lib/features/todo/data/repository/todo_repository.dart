import 'package:taskflow/features/todo/model/todo_model.dart';

abstract interface class TodoRepository{
  Future<List<TodoModel>> fetchTodos();
}