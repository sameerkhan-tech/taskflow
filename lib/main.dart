import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/features/todo/data/repository/mock_todo_repository_impl.dart';
import 'package:taskflow/features/todo/view/home_page.dart';
import 'package:taskflow/features/todo/view_model/todo_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => TodoBloc(MockTodoRepositoryImpl()),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: HomePage(),
    );
  }
}