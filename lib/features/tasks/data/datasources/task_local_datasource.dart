import 'package:injectable/injectable.dart';
import 'package:offs/core/database/daos/tasks_dao.dart';
import 'package:offs/core/database/database.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskData>> getTasks();
  Future<TaskData> getTask(int id);
  Future<int> createTask(TasksCompanion task);
  Future<bool> updateTask(TasksCompanion task);
  Future<int> deleteTask(int id);
}

@LazySingleton(as: TaskLocalDataSource)
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final TasksDao _tasksDao;

  TaskLocalDataSourceImpl(this._tasksDao);

  @override
  Future<List<TaskData>> getTasks() => _tasksDao.getAllTasks();

  @override
  Future<TaskData> getTask(int id) => _tasksDao.getTaskById(id);

  @override
  Future<int> createTask(TasksCompanion task) => _tasksDao.insertTask(task);

  @override
  Future<bool> updateTask(TasksCompanion task) => _tasksDao.updateTask(task);

  @override
  Future<int> deleteTask(int id) => _tasksDao.deleteTaskById(id);
}
