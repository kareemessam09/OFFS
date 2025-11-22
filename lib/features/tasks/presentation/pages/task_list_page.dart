import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offs/core/di/injection.dart';
import 'package:offs/core/utils/enums.dart';
import 'package:offs/features/tasks/domain/entities/task.dart';
import 'package:offs/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:offs/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:offs/features/tasks/presentation/widgets/task_card.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TaskBloc>()..add(LoadTasks()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tasks')),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              if (state.tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks found',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create one',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.tasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailPage(task: task),
                        ),
                      ).then((_) {
                        // Refresh list when coming back
                        if (context.mounted) {
                          context.read<TaskBloc>().add(LoadTasks());
                        }
                      });
                    },
                    onStatusChanged: (value) {
                      if (value != null) {
                        final newStatus = value
                            ? TaskStatus.completed
                            : TaskStatus.pending;
                        final updatedTask = Task(
                          id: task.id,
                          title: task.title,
                          description: task.description,
                          status: newStatus,
                          dueDate: task.dueDate,
                          createdAt: task.createdAt,
                          updatedAt: DateTime.now(),
                        );
                        context.read<TaskBloc>().add(
                          UpdateTaskEvent(updatedTask),
                        );
                      }
                    },
                  );
                },
              );
            } else if (state is TaskError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TaskBloc>().add(LoadTasks());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskDetailPage()),
                ).then((_) {
                  if (context.mounted) {
                    context.read<TaskBloc>().add(LoadTasks());
                  }
                });
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
