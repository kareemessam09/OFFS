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
                return const Center(child: Text('No tasks found'));
              }
              return ListView.builder(
                itemCount: state.tasks.length,
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
                        context.read<TaskBloc>().add(LoadTasks());
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
              return Center(child: Text('Error: ${state.message}'));
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
                  context.read<TaskBloc>().add(LoadTasks());
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
