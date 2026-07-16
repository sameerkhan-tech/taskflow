import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskflow/features/todo/model/todo_model.dart';
import 'package:taskflow/features/todo/model/todo_priority.dart';
import 'package:taskflow/features/todo/view_model/todo_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dateFormater = DateFormat('EEE, d MMM');
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
                title: Text(_greetingMessage()),
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
                SliverFillRemaining(child: _errorUi(state, theme, context))
              // List UI
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.builder(
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      final todo = state.data[index];
                      return _todoCardUi(todo, theme);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Center _errorUi(TodoState state, ThemeData theme, BuildContext context) {
    return Center(
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
    );
  }

  Card _todoCardUi(TodoModel todo, ThemeData theme) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
                _chip(
                  theme: theme,
                  child: Text(
                    todo.category ?? 'General',
                    style: theme.textTheme.labelSmall,
                  ),
                ),

                _chip(
                  theme: theme,
                  child: _buildPriorityChipContent(theme, todo),
                ),

                if (todo.dueDate != null)
                  _iconChip(
                    theme,
                    label: _dateFormater.format(todo.dueDate!),
                    icon: Icons.calendar_month,
                    foregroundColor: Colors.redAccent,
                  ),
                if (todo.reminderDate != null)
                  _iconChip(
                    theme,
                    label: _dateFormater.format(todo.reminderDate!),
                    icon: Icons.alarm,
                    foregroundColor: Colors.blueAccent,
                  ),
              ],
            ),
          ],
        ),
        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
      ),
    );
  }

  Widget _buildPriorityChipContent(ThemeData theme, TodoModel todo) {
    final IconData iconData = switch (todo.priority) {
      TodoPriority.low => Icons.arrow_downward,
      TodoPriority.medium => Icons.remove,
      TodoPriority.high => Icons.arrow_upward,
      TodoPriority.urgent => Icons.star,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          size: 14,
          color: (todo.priority == TodoPriority.urgent)
              ? Colors.redAccent
              : null,
        ),
        const SizedBox(width: 4),
        Text(
          TodoPriority.values[todo.priority.index].name.toUpperCase(),
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }

  Container _chip({required ThemeData theme, required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _iconChip(
    ThemeData theme, {
    required String label,
    required IconData icon,
    required Color foregroundColor,
  }) {
    return _chip(
      theme: theme,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: foregroundColor),
          ),
        ],
      ),
    );
  }

 String _greetingMessage() {
  final hour = DateTime.now().hour;

  if (hour < 5) return "Hello, Night Owl 🌙";
  if (hour < 12) return "Hello, Good morning 🌄";
  if (hour < 17) return "Hello, Good afternoon ☀️";
  if (hour < 21) return "Hello, Good evening 🌇";

  return "Hello, Working late? 🌛";
}
}
