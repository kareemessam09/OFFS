import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
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
    // TODO: Implement API call
    // final response = await _dio.get('/tasks');
    // return (response.data as List).map((e) => TaskModel.fromJson(e)).toList();
    return [];
  }

  @override
  Future<TaskModel> getTask(int id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(int id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
