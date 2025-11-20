import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:offs/core/errors/failures.dart';
import 'package:offs/features/tasks/domain/entities/task.dart';
import 'package:offs/features/tasks/domain/repositories/task_repository.dart';

@lazySingleton
class GetTasks {
  final TaskRepository _repository;

  GetTasks(this._repository);

  Future<Either<Failure, List<Task>>> call() async {
    return await _repository.getTasks();
  }
}
