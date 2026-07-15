import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/constants/app_exception.dart';
import 'package:taskflow/features/todo/data/repository/todo_repository.dart';
import 'package:taskflow/features/todo/model/todo_model.dart';

part 'todo_state.dart';
part 'todo_event.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc(TodoRepository todoRepository)
    : _todoRepository = todoRepository, super(
        const TodoState(
          todoStatus: TodoStatus.initial,
          data: [],
          errorMessage: null,
        ),
      ) {
    on<FetchTodos>((event, emit) async {
      try {
        emit(state.copyWith(todoStatus: TodoStatus.loading));
        final List<TodoModel> todos = await _todoRepository.fetchTodos();
        emit(state.copyWith(todoStatus: TodoStatus.success, data: todos));
      } on AppException catch (e) {
        emit(
          state.copyWith(
            todoStatus: TodoStatus.error,
            errorMessage: e.errorMessage,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            todoStatus: TodoStatus.error,
            errorMessage: 'Something went wrong, please try again later',
          ),
        );
      }
    });
  }
}
