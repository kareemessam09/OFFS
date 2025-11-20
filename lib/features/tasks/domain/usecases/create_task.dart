import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:offs/core/errors/failures.dart';
import 'package:offs/features/tasks/domain/entities/task.dart';
import 'package:offs/features/tasks/domain/repositories/task_repository.dart';

@lazySingleton
class CreateTask {
  final TaskRepository _repository;

  CreateTask(this._repository);

  Future<Either<Failure, Task>> call(Task task) async {
    return await _repository.createTask(task);
  }
}
