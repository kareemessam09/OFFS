import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/tasks_table.dart';
import 'tables/inventory_table.dart';
import 'tables/sync_queue_table.dart';
import 'tables/attachments_table.dart';
import 'daos/tasks_dao.dart';
import 'daos/sync_queue_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Tasks, InventoryItems, SyncQueue, Attachments],
  daos: [TasksDao, SyncQueueDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
