import 'package:fpdart/fpdart.dart' hide Task;
import 'package:offs/core/errors/failures.dart';
import 'package:offs/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, Task>> getTask(int id);
  Future<Either<Failure, Task>> createTask(Task task);
  Future<Either<Failure, Task>> updateTask(Task task);
  Future<Either<Failure, void>> deleteTask(int id);
}
