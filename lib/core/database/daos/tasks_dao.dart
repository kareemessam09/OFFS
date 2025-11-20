import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/database/database.dart';
import 'package:offs/core/database/tables/tasks_table.dart';

part 'tasks_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  Future<List<TaskData>> getAllTasks() => select(tasks).get();

  Stream<List<TaskData>> watchAllTasks() => select(tasks).watch();

  Future<TaskData> getTaskById(int id) =>
      (select(tasks)..where((t) => t.id.equals(id))).getSingle();

  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);

  Future<bool> updateTask(TasksCompanion task) => update(tasks).replace(task);

  Future<int> deleteTaskById(int id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();
}
