import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskflow/features/todo/model/todo_priority.dart';
import 'package:taskflow/features/todo/view_model/todo_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dateFormater = DateFormat('EEE, d MMM');
  @override
  void initState() {
    context.read<TodoBloc>().add(FetchTodos());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(greetingMessage()),
                titleTextStyle: theme.textTheme.titleMedium,
              ),
              // Initial loader
              if (state.isInitialLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              // Empty state UI
              else if (state.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text('Click + to add todos!')),
                )
              // Error state UI
              else if (state.hasError)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.errorContainer,
                          ),
                          onPressed: () {
                            context.read<TodoBloc>().add(FetchTodos());
                          },
                          child: Text(
                            'Retry',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              // List UI
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.builder(
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      final todo = state.data[index];
                      return Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 8,
                          ),
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (value) {},
                            shape: CircleBorder(),
                          ),
                          title: Text(
                            todo.todo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (todo.description != null)
                                Text(
                                  todo.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              SizedBox(height: 4),
                              Wrap(
                                runSpacing: 4,
                                spacing: 4,
                                children: [
                                  customChip(
                                    theme: theme,
                                    child: Text(
                                      todo.category ?? 'General',
                                      style: theme.textTheme.labelSmall,
                                    ),
                                  ),
                                  customChip(
                                    theme: theme,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (todo.priority == TodoPriority.low)
                                          Icon(Icons.arrow_downward, size: 14)
                                        else if (todo.priority ==
                                            TodoPriority.medium)
                                          Icon(
                                            Icons.linear_scale_outlined,
                                            size: 14,
                                          )
                                        else if (todo.priority ==
                                            TodoPriority.high)
                                          Icon(Icons.arrow_upward, size: 14)
                                        else
                                          Icon(
                                            Icons.star,
                                            color: Colors.redAccent,
                                            size: 14,
                                          ),

                                        Text(
                                          (TodoPriority
                                                  .values[todo.priority.index]
                                                  .name)
                                              .toUpperCase(),
                                          style: theme.textTheme.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (todo.dueDate != null)
                                    customChip(
                                      theme: theme,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            size: 14,
                                            color: Colors.redAccent,
                                          ),
                                          Text(
                                            dateFormater.format(todo.dueDate!),
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  color: Colors.redAccent,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (todo.reminderDate != null)
                                    customChip(
                                      theme: theme,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.alarm_rounded,
                                            size: 14,
                                            color: Colors.blueAccent,
                                          ),
                                          Text(
                                            dateFormater.format(
                                              todo.reminderDate!,
                                            ),
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  color: Colors.blueAccent,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Container customChip({required ThemeData theme, required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

String greetingMessage() {
  final int hour = DateTime.now().hour;

  if (hour < 5) {
    return "Hello, Night Owl 🌙";
  } else if (hour > 5 && hour < 12) {
    return "Hello, Good morning 🌄";
  } else if (hour > 12 && hour < 17) {
    return "Hello, Good afternoon ☀️";
  } else if (hour > 17 && hour < 21) {
    return "Hello, Good evening 🌇";
  } else {
    return "Hello, Working late? 🌛";
  }
}
