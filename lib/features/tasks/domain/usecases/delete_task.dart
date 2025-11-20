import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/errors/failures.dart';
import 'package:offs/features/tasks/domain/repositories/task_repository.dart';

@lazySingleton
class DeleteTask {
  final TaskRepository _repository;

  DeleteTask(this._repository);

  Future<Either<Failure, void>> call(int id) async {
    return await _repository.deleteTask(id);
  }
}
