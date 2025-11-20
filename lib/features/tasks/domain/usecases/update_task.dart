import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:offs/core/errors/failures.dart';
import 'package:offs/features/tasks/domain/entities/task.dart';
import 'package:offs/features/tasks/domain/repositories/task_repository.dart';

@lazySingleton
class UpdateTask {
  final TaskRepository _repository;

  UpdateTask(this._repository);

  Future<Either<Failure, Task>> call(Task task) async {
    return await _repository.updateTask(task);
  }
}
