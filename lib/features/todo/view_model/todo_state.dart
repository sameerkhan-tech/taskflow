part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  final TodoStatus todoStatus;
  final List<TodoModel> data;
  final String? errorMessage;

  const TodoState({
    required this.todoStatus,
    required this.data,
    required this.errorMessage,
  });

  TodoState copyWith({
    TodoStatus? todoStatus,
    List<TodoModel>? data,
    String? errorMessage,
  }) => TodoState(
    todoStatus: todoStatus ?? this.todoStatus,
    data: data ?? this.data,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [todoStatus, data, errorMessage];

  // UI helper getters
  bool get isInitialLoading => todoStatus == TodoStatus.loading && data.isEmpty;
  bool get isEmpty => todoStatus == TodoStatus.success && data.isEmpty;
  bool get hasError => todoStatus == TodoStatus.error && data.isEmpty;
}
