import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/utils/enums.dart';
import 'package:offs/features/tasks/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTask(int id);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(int id);
}

@LazySingleton(as: TaskRemoteDataSource)
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio _dio;

  TaskRemoteDataSourceImpl(this._dio);

  @override
  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      TaskModel(
        id: 101,
        title: 'Remote Task 1',
        description: 'This task came from the "server"',
        status: TaskStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TaskModel(
        id: 102,
        title: 'Remote Task 2',
        description: 'Another remote task',
        status: TaskStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  @override
  Future<TaskModel> getTask(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return TaskModel(
      id: id,
      title: 'Remote Task $id',
      description: 'Description for task $id',
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate server assigning an ID
    return TaskModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: task.title,
      description: task.description,
      status: task.status,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return task;
  }

  @override
  Future<void> deleteTask(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
