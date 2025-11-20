import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/features/tasks/domain/entities/task.dart';
import 'package:offs/features/tasks/domain/usecases/create_task.dart';
import 'package:offs/features/tasks/domain/usecases/delete_task.dart';
import 'package:offs/features/tasks/domain/usecases/get_tasks.dart';
import 'package:offs/features/tasks/domain/usecases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks _getTasks;
  final CreateTask _createTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;

  TaskBloc(this._getTasks, this._createTask, this._updateTask, this._deleteTask)
    : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await _getTasks();
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskLoaded(tasks)),
    );
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    // Optimistic update or wait for result?
    // For now, let's wait for result and reload.
    // Or better, append to list if loaded.
    final currentState = state;
    if (currentState is TaskLoaded) {
      // emit(TaskLoading()); // Optional: show loading indicator
      final result = await _createTask(event.task);
      result.fold((failure) => emit(TaskError(failure.message)), (newTask) {
        final updatedTasks = List<Task>.from(currentState.tasks)..add(newTask);
        emit(TaskLoaded(updatedTasks));
      });
    } else {
      // If not loaded, just load all
      await _createTask(event.task);
      add(LoadTasks());
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      final result = await _updateTask(event.task);
      result.fold((failure) => emit(TaskError(failure.message)), (updatedTask) {
        final updatedTasks = currentState.tasks.map((t) {
          return t.id == updatedTask.id ? updatedTask : t;
        }).toList();
        emit(TaskLoaded(updatedTasks));
      });
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      final result = await _deleteTask(event.id);
      result.fold((failure) => emit(TaskError(failure.message)), (_) {
        final updatedTasks = currentState.tasks
            .where((t) => t.id != event.id)
            .toList();
        emit(TaskLoaded(updatedTasks));
      });
    }
  }
}
