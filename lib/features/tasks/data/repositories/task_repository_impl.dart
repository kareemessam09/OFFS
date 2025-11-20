import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:offs/core/database/daos/sync_queue_dao.dart';
import 'package:offs/core/database/database.dart';
import 'package:offs/core/errors/exceptions.dart';
import 'package:offs/core/errors/failures.dart';
import 'package:offs/core/utils/enums.dart';
import 'package:offs/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:offs/features/tasks/data/models/task_model.dart';
import 'package:offs/features/tasks/domain/entities/task.dart';
import 'package:offs/features/tasks/domain/repositories/task_repository.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;
  final SyncQueueDao _syncQueueDao;

  TaskRepositoryImpl(this._localDataSource, this._syncQueueDao);

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final taskDataList = await _localDataSource.getTasks();
      final tasks = taskDataList.map((data) => _mapToEntity(data)).toList();
      return Right(tasks);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> getTask(int id) async {
    try {
      final data = await _localDataSource.getTask(id);
      return Right(_mapToEntity(data));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    try {
      final companion = TasksCompanion(
        title: Value(task.title),
        description: Value(task.description),
        status: Value(task.status.toShortString()),
        dueDate: Value(task.dueDate),
        createdAt: Value(task.createdAt),
        updatedAt: Value(task.updatedAt),
      );
      final id = await _localDataSource.createTask(companion);
      // Fetch the created task to return it
      final createdData = await _localDataSource.getTask(id);
      final createdTask = _mapToEntity(createdData);

      // Queue for sync
      final taskModel = TaskModel.fromEntity(createdTask);
      await _syncQueueDao.addToQueue(
        SyncQueueCompanion(
          operation: const Value('create'),
          entityType: const Value('task'),
          entityId: Value(createdTask.id),
          payload: Value(jsonEncode(taskModel.toJson())),
          createdAt: Value(DateTime.now()),
          status: const Value('pending'),
        ),
      );

      return Right(createdTask);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final companion = TasksCompanion(
        id: Value(task.id),
        title: Value(task.title),
        description: Value(task.description),
        status: Value(task.status.toShortString()),
        dueDate: Value(task.dueDate),
        updatedAt: Value(DateTime.now()),
      );
      await _localDataSource.updateTask(companion);
      final updatedData = await _localDataSource.getTask(task.id);
      final updatedTask = _mapToEntity(updatedData);

      // Queue for sync
      final taskModel = TaskModel.fromEntity(updatedTask);
      await _syncQueueDao.addToQueue(
        SyncQueueCompanion(
          operation: const Value('update'),
          entityType: const Value('task'),
          entityId: Value(updatedTask.id),
          payload: Value(jsonEncode(taskModel.toJson())),
          createdAt: Value(DateTime.now()),
          status: const Value('pending'),
        ),
      );

      return Right(updatedTask);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(int id) async {
    try {
      await _localDataSource.deleteTask(id);

      // Queue for sync
      await _syncQueueDao.addToQueue(
        SyncQueueCompanion(
          operation: const Value('delete'),
          entityType: const Value('task'),
          entityId: Value(id),
          payload: const Value(
            '{}',
          ), // No payload needed for delete, or maybe just ID
          createdAt: Value(DateTime.now()),
          status: const Value('pending'),
        ),
      );

      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  Task _mapToEntity(TaskData data) {
    return Task(
      id: data.id,
      title: data.title,
      description: data.description,
      status: TaskStatus.fromString(data.status),
      dueDate: data.dueDate,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}
