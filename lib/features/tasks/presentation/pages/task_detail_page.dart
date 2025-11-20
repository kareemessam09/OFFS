import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:offs/core/di/injection.dart';
import 'package:offs/core/utils/enums.dart';
import 'package:offs/features/tasks/domain/entities/task.dart';
import 'package:offs/features/tasks/presentation/bloc/task_bloc.dart';

class TaskDetailPage extends StatefulWidget {
  final Task? task;

  const TaskDetailPage({super.key, this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;
  TaskStatus _status = TaskStatus.pending;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _dueDate = widget.task?.dueDate;
    _status = widget.task?.status ?? TaskStatus.pending;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return BlocProvider(
      create: (context) => getIt<TaskBloc>(),
      child: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskLoaded) {
            // Task saved successfully
            Navigator.pop(context);
          } else if (state is TaskError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditing ? 'Edit Task' : 'New Task'),
              actions: [
                if (isEditing)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _confirmDelete(context);
                    },
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Due Date'),
                      subtitle: Text(
                        _dueDate != null
                            ? DateFormat('MMM d, y').format(_dueDate!)
                            : 'No date set',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<TaskStatus>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: TaskStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.toShortString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _status = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: state is TaskLoading
                          ? null
                          : () => _saveTask(context),
                      child: state is TaskLoading
                          ? const CircularProgressIndicator()
                          : Text(isEditing ? 'Update Task' : 'Create Task'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final taskBloc = context.read<TaskBloc>();
      final title = _titleController.text;
      final description = _descriptionController.text;

      if (widget.task != null) {
        // Update
        final updatedTask = Task(
          id: widget.task!.id,
          title: title,
          description: description,
          status: _status,
          dueDate: _dueDate,
          createdAt: widget.task!.createdAt,
          updatedAt: DateTime.now(),
        );
        taskBloc.add(UpdateTaskEvent(updatedTask));
      } else {
        // Create
        final newTask = Task(
          id: 0, // ID will be ignored/generated by DB
          title: title,
          description: description,
          status: _status,
          dueDate: _dueDate,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        taskBloc.add(AddTaskEvent(newTask));
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              // Use the Bloc from the parent context (TaskDetailPage's BlocProvider)
              // But wait, the dialog context is different.
              // We need to capture the bloc before showing dialog or use context.read if available.
              // Since dialog is pushed, it might not have access to the BlocProvider if it's not in the tree above the dialog.
              // Actually showDialog puts the dialog in the root overlay.
              // So we need to pass the bloc or use a closure.
              _deleteTask(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteTask(BuildContext context) {
    // context here is the one from build method, which has the BlocProvider
    context.read<TaskBloc>().add(DeleteTaskEvent(widget.task!.id));
  }
}
